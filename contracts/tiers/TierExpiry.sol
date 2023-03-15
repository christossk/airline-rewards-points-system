pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TierManagement.sol";
import "./UserRegistration.sol";

contract TierExpiry is Ownable {
    // Instance of TierManagement contract
    TierManagement private tierManagement;

    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Mapping of user ID to tier expiry timestamp
    mapping(uint256 => uint256) private tierExpiry;

    // Duration for tiers in seconds (default: 1 year)
    uint256 public constant TIER_DURATION = 365 days;

    constructor(address _tierManagementAddress, address _userRegistrationAddress) {
        tierManagement = TierManagement(_tierManagementAddress);
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Update a user's tier expiry timestamp.
     * This function can only be called by the contract owner.
     * @param _userId The user ID of the user.
     * @param _expiry The new tier expiry timestamp.
     */
    function updateTierExpiry(uint256 _userId, uint256 _expiry) external onlyOwner {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");
        tierExpiry[_userId] = _expiry;
    }

    /**
     * @dev Get a user's tier expiry timestamp.
     * @param _userId The user ID of the user.
     * @return The tier expiry timestamp.
     */
    function getTierExpiry(uint256 _userId) external view returns (uint256) {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");
        return tierExpiry[_userId];
    }

    /**
     * @dev Check if a user's tier has expired.
     * @param _userId The user ID of the user.
     * @return True if the user's tier has expired, false otherwise.
     */
    function hasTierExpired(uint256 _userId) external view returns (bool) {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");
        return block.timestamp > tierExpiry[_userId];
    }
}
