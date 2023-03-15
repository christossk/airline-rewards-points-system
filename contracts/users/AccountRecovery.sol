pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AccountRecovery is Ownable {
    // Mapping from user's wallet address to recovery email
    mapping(address => string) public recoveryEmails;

    // Event emitted when a recovery email is set or updated
    event RecoveryEmailSet(address indexed user, string email);

    /**
     * @dev Set or update the recovery email for the given user's wallet address.
     * @param _user The wallet address of the user.
     * @param _email The recovery email to be set or updated.
     */
    function setRecoveryEmail(address _user, string memory _email) external {
        require(_user != address(0), "Invalid user address");
        require(_user == msg.sender || owner() == msg.sender, "Not authorized to set recovery email");

        // Set or update the user's recovery email
        recoveryEmails[_user] = _email;

        emit RecoveryEmailSet(_user, _email);
    }

    /**
     * @dev Recover a user's account by associating a new wallet address with the existing recovery email.
     * @param _oldUser The old wallet address of the user.
     * @param _newUser The new wallet address of the user.
     * @param _email The recovery email associated with the user.
     */
    function recoverAccount(address _oldUser, address _newUser, string memory _email) external onlyOwner {
        require(_oldUser != address(0), "Invalid old user address");
        require(_newUser != address(0), "Invalid new user address");
        require(keccak256(abi.encodePacked(recoveryEmails[_oldUser])) == keccak256(abi.encodePacked(_email)), "Recovery email does not match");

        // Transfer the recovery email to the new wallet address
        recoveryEmails[_newUser] = _email;

        // Delete the recovery email from the old wallet address
        delete recoveryEmails[_oldUser];

        emit RecoveryEmailSet(_newUser, _email);
    }
}
