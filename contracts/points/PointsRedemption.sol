pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract PointsRedemption is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Mapping from reward item ID to reward item information
    mapping(uint256 => RewardItem) public rewardItems;

    // Reward item struct containing reward item information
    struct RewardItem {
        uint256 id;
        string name;
        uint256 pointsRequired;
        bool active;
    }

    // Counter to keep track of reward item IDs
    uint256 private rewardItemIdCounter;

    // Event emitted when a reward item is added
    event RewardItemAdded(uint256 indexed itemId, string name, uint256 pointsRequired);

    // Event emitted when a reward item is redeemed
    event RewardItemRedeemed(address indexed user, uint256 indexed itemId);

    constructor(address _pointsManagementAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
    }

    /**
     * @dev Add a new reward item to the contract.
     * @param _name The name of the reward item.
     * @param _pointsRequired The number of points required to redeem the reward item.
     */
    function addRewardItem(string memory _name, uint256 _pointsRequired) external onlyOwner {
        require(_pointsRequired > 0, "Points required should be greater than zero");

        rewardItemIdCounter++;

        RewardItem memory newRewardItem = RewardItem(rewardItemIdCounter, _name, _pointsRequired, true);

        rewardItems[rewardItemIdCounter] = newRewardItem;

        emit RewardItemAdded(rewardItemIdCounter, _name, _pointsRequired);
    }

    /**
     * @dev Redeem a reward item using points.
     * @param _itemId The ID of the reward item to redeem.
     */
    function redeemRewardItem(uint256 _itemId) external {
        RewardItem storage rewardItem = rewardItems[_itemId];

        require(rewardItem.active, "Reward item is not active");
        require(pointsManagement.getPointsBalance(msg.sender) >= rewardItem.pointsRequired, "Insufficient points");

        pointsManagement.redeemPoints(msg.sender, rewardItem.pointsRequired);

        emit RewardItemRedeemed(msg.sender, _itemId);
    }

    /**
     * @dev Update the status of a reward item.
     * @param _itemId The ID of the reward item.
     * @param _active The new status of the reward item.
     */
    function updateRewardItemStatus(uint256 _itemId, bool _active) external onlyOwner {
        require(rewardItems[_itemId].id != 0, "Reward item does not exist");

        rewardItems[_itemId].active = _active;
    }
}
