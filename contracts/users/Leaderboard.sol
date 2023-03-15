pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract Leaderboard is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Struct to store leaderboard entry information
    struct LeaderboardEntry {
        uint256 userId;
        uint256 points;
    }

    // Array containing all leaderboard entries
    LeaderboardEntry[] private leaderboard;

    constructor(address _pointsManagementAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
    }

    /**
     * @dev Update the leaderboard with the latest points.
     * This function can only be called by the contract owner.
     */
    function updateLeaderboard() external onlyOwner {
        uint256 totalUsers = pointsManagement.getUsersCount();

        // Clear the current leaderboard
        delete leaderboard;

        // Update the leaderboard with the latest points
        for (uint256 i = 0; i < totalUsers; i++) {
            uint256 points = pointsManagement.getPointsByUserId(i);
            leaderboard.push(LeaderboardEntry(i, points));
        }

        // Sort the leaderboard in descending order of points
        _sortLeaderboard();
    }

    /**
     * @dev Get the top N users from the leaderboard.
     * @param _topN The number of top users to return.
     * @return An array of top N leaderboard entries.
     */
    function getTopNUsers(uint256 _topN) external view returns (LeaderboardEntry[] memory) {
        uint256 leaderboardSize = leaderboard.length;
        uint256 resultSize = _topN < leaderboardSize ? _topN : leaderboardSize;

        LeaderboardEntry[] memory topNUsers = new LeaderboardEntry[](resultSize);

        for (uint256 i = 0; i < resultSize; i++) {
            topNUsers[i] = leaderboard[i];
        }

        return topNUsers;
    }

    /**
     * @dev Sort the leaderboard using the bubble sort algorithm.
     * This is a private helper function.
     */
    function _sortLeaderboard() private {
        uint256 n = leaderboard.length;

        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = 0; j < n - i - 1; j++) {
                if (leaderboard[j].points < leaderboard[j + 1].points) {
                    // Swap leaderboard entries
                    (leaderboard[j], leaderboard[j + 1]) = (leaderboard[j + 1], leaderboard[j]);
                }
            }
        }
    }
}
