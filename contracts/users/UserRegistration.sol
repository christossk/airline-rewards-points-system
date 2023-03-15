pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UserRegistration is Ownable {
    using Counters for Counters.Counter;

    // User struct containing user information
    struct User {
        uint256 id;
        string fullName;
        string email;
        address wallet;
        bool isActive;
    }

    // Counter to keep track of user IDs
    Counters.Counter private _userIds;

    // Mapping from user's wallet address to user's ID
    mapping(address => uint256) public userIds;

    // Mapping from user's ID to user information
    mapping(uint256 => User) public users;

    // Event emitted when a user is registered
    event UserRegistered(uint256 indexed userId, string fullName, string email, address wallet);

    /**
     * @dev Register a new user with their full name, email, and wallet address.
     * @param _fullName The full name of the user.
     * @param _email The email address of the user.
     * @param _wallet The wallet address of the user.
     */
    function registerUser(string memory _fullName, string memory _email, address _wallet) external onlyOwner {
        require(_wallet != address(0), "Invalid wallet address");
        require(userIds[_wallet] == 0, "User already registered");
        
        // Increment user IDs counter
        _userIds.increment();
        uint256 newUserId = _userIds.current();

        // Create a new user
        User memory newUser = User(newUserId, _fullName, _email, _wallet, true);

        // Update mappings
        userIds[_wallet] = newUserId;
        users[newUserId] = newUser;

        emit UserRegistered(newUserId, _fullName, _email, _wallet);
    }

    /**
     * @dev Update a user's active status.
     * @param _userId The ID of the user.
     * @param _isActive The new active status for the user.
     */
    function updateUserStatus(uint256 _userId, bool _isActive) external onlyOwner {
        require(users[_userId].id != 0, "User does not exist");
        
        users[_userId].isActive = _isActive;
    }
}
