pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract PointsHistory is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Struct to store points transaction information
    struct PointsTransaction {
        uint256 userId;
        uint256 timestamp;
        int256 points;
        string description;
    }

    // Mapping of user ID to an array of their points transactions
    mapping(uint256 => PointsTransaction[]) private pointsHistory;

    constructor(address _pointsManagementAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
    }

    /**
     * @dev Add a points transaction for a user.
     * This function can only be called by the contract owner.
     * @param _userId The user ID of the user.
     * @param _points The points to be added (positive) or subtracted (negative).
     * @param _description A description of the transaction.
     */
    function addPointsTransaction(uint256 _userId, int256 _points, string memory _description) external onlyOwner {
        require(pointsManagement.isUserRegistered(_userId), "User is not registered");

        PointsTransaction memory transaction = PointsTransaction(_userId, block.timestamp, _points, _description);
        pointsHistory[_userId].push(transaction);
    }

    /**
     * @dev Get the points history for a user.
     * @param _userId The user ID of the user.
     * @return An array of the user's points transactions.
     */
    function getPointsHistory(uint256 _userId) external view returns (PointsTransaction[] memory) {
        require(pointsManagement.isUserRegistered(_userId), "User is not registered");
        return pointsHistory[_userId];
    }
}
