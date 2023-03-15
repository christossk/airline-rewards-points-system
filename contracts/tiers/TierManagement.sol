pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract TierManagement is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Tier struct containing tier information
    struct Tier {
        uint256 id;
        string name;
        uint256 pointsRequired;
    }

    // Array containing all tiers
    Tier[] public tiers;

    // Event emitted when a new tier is added
    event TierAdded(uint256 indexed tierId, string name, uint256 pointsRequired);

    // Event emitted when a tier is updated
    event TierUpdated(uint256 indexed tierId, string newName, uint256 newPointsRequired);

    constructor(address _pointsManagementAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
    }

    /**
     * @dev Add a new tier to the contract.
     * @param _name The name of the tier.
     * @param _pointsRequired The number of points required to reach the tier.
     */
    function addTier(string memory _name, uint256 _pointsRequired) external onlyOwner {
        require(_pointsRequired > 0, "Points required should be greater than zero");

        uint256 tierId = tiers.length;

        Tier memory newTier = Tier(tierId, _name, _pointsRequired);

        tiers.push(newTier);

        emit TierAdded(tierId, _name, _pointsRequired);
    }

    /**
     * @dev Update the information of an existing tier.
     * @param _tierId The ID of the tier to update.
     * @param _newName The new name for the tier.
     * @param _newPointsRequired The new number of points required to reach the tier.
     */
    function updateTier(uint256 _tierId, string memory _newName, uint256 _newPointsRequired) external onlyOwner {
        require(_tierId < tiers.length, "Invalid tier ID");
        require(_newPointsRequired > 0, "Points required should be greater than zero");

        tiers[_tierId].name = _newName;
        tiers[_tierId].pointsRequired = _newPointsRequired;

        emit TierUpdated(_tierId, _newName, _newPointsRequired);
    }

    /**
     * @dev Get the current tier for a user based on their points balance.
     * @param _user The wallet address of the user.
     * @return tier The user's current tier.
     */
    function getUserTier(address _user) external view returns (Tier memory tier) {
        uint256 userPoints = pointsManagement.getPointsBalance(_user);
        uint256 highestTier = 0;

        for (uint256 i = 0; i < tiers.length; i++) {
            if (userPoints >= tiers[i].pointsRequired && tiers[i].pointsRequired >= tiers[highestTier].pointsRequired) {
                highestTier = i;
            }
        }

        return tiers[highestTier];
    }
}
