pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserRegistration.sol";

contract Notifications is Ownable {
    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Struct to store notification information
    struct Notification {
        uint256 id;
        uint256 userId;
        string message;
        bool read;
    }

    // Array containing all notifications
    Notification[] private notifications;

    // Mapping to store notifications by user
    mapping(uint256 => uint256[]) private userNotifications;

    constructor(address _userRegistrationAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Create a new notification.
     * This function can only be called by the contract owner.
     * @param _userId The ID of the user associated with the notification.
     * @param _message The message of the notification.
     */
    function createNotification(uint256 _userId, string memory _message) external onlyOwner {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");

        Notification memory newNotification = Notification(notifications.length, _userId, _message, false);
        notifications.push(newNotification);
        userNotifications[_userId].push(newNotification.id);
    }

    /**
     * @dev Set the read status of a notification.
     * @param _notificationId The ID of the notification.
     */
    function setReadStatus(uint256 _notificationId) external {
        require(_notificationId < notifications.length, "Invalid notification ID");
        uint256 userId = notifications[_notificationId].userId;
        require(msg.sender == userRegistration.getUserWallet(userId), "Unauthorized access");

        notifications[_notificationId].read = true;
    }

    /**
     * @dev Get the details of a notification.
     * @param _notificationId The ID of the notification.
     * @return userId, message, read
     */
    function getNotificationDetails(uint256 _notificationId)
        external
        view
        returns (
            uint256 userId,
            string memory message,
            bool read
        )
    {
        require(_notificationId < notifications.length, "Invalid notification ID");

        Notification memory notification = notifications[_notificationId];
        return (notification.userId, notification.message, notification.read);
    }

    /**
     * @dev Get the notifications associated with a user.
     * @param _userId The ID of the user.
     * @return A list of notification IDs
     */
    function getUserNotifications(uint256 _userId) external view returns (uint256[] memory) {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");

        return userNotifications[_userId];
    }
}
