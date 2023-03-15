pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UserPreferences is Ownable {
    struct Preferences {
        bool receiveEmails;
        bool receivePromotions;
        bool receiveNotifications;
    }

    // Mapping from user's wallet address to user's preferences
    mapping(address => Preferences) public userPreferences;

    // Event emitted when a user's preferences are updated
    event PreferencesUpdated(address indexed user, bool receiveEmails, bool receivePromotions, bool receiveNotifications);

    /**
     * @dev Update the preferences for the given user's wallet address.
     * @param _user The wallet address of the user.
     * @param _receiveEmails The updated preference for receiving emails.
     * @param _receivePromotions The updated preference for receiving promotions.
     * @param _receiveNotifications The updated preference for receiving notifications.
     */
    function updateUserPreferences(
        address _user,
        bool _receiveEmails,
        bool _receivePromotions,
        bool _receiveNotifications
    ) external {
        require(_user != address(0), "Invalid user address");
        require(_user == msg.sender || owner() == msg.sender, "Not authorized to update preferences");

        // Update the user's preferences
        Preferences storage preferences = userPreferences[_user];
        preferences.receiveEmails = _receiveEmails;
        preferences.receivePromotions = _receivePromotions;
        preferences.receiveNotifications = _receiveNotifications;

        emit PreferencesUpdated(_user, _receiveEmails, _receivePromotions, _receiveNotifications);
    }
}
