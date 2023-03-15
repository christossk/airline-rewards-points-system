pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract PromotionsManagement is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Promotion struct containing promotion information
    struct Promotion {
        uint256 id;
        string name;
        uint256 bonusPoints;
        uint256 startTime;
        uint256 endTime;
        bool active;
    }

    // Array containing all promotions
    Promotion[] public promotions;

    // Event emitted when a new promotion is created
    event PromotionCreated(uint256 indexed promotionId, string name, uint256 bonusPoints, uint256 startTime, uint256 endTime);

    // Event emitted when a promotion is updated
    event PromotionUpdated(uint256 indexed promotionId, string newName, uint256 newBonusPoints, uint256 newStartTime, uint256 newEndTime, bool newActive);

    constructor(address _pointsManagementAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
    }

    /**
     * @dev Create a new promotion.
     * @param _name The name of the promotion.
     * @param _bonusPoints The number of bonus points for the promotion.
     * @param _startTime The start time of the promotion (UNIX timestamp).
     * @param _endTime The end time of the promotion (UNIX timestamp).
     */
    function createPromotion(
        string memory _name,
        uint256 _bonusPoints,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyOwner {
        require(_bonusPoints > 0, "Bonus points must be greater than zero");
        require(_startTime < _endTime, "Start time must be earlier than end time");

        uint256 promotionId = promotions.length;

        Promotion memory newPromotion = Promotion(promotionId, _name, _bonusPoints, _startTime, _endTime, true);

        promotions.push(newPromotion);

        emit PromotionCreated(promotionId, _name, _bonusPoints, _startTime, _endTime);
    }

    /**
     * @dev Update an existing promotion.
     * @param _promotionId The ID of the promotion to update.
     * @param _newName The new name for the promotion.
     * @param _newBonusPoints The new number of bonus points for the promotion.
     * @param _newStartTime The new start time of the promotion (UNIX timestamp).
     * @param _newEndTime The new end time of the promotion (UNIX timestamp).
     * @param _newActive The new active status of the promotion.
     */
    function updatePromotion(
        uint256 _promotionId,
        string memory _newName,
        uint256 _newBonusPoints,
        uint256 _newStartTime,
        uint256 _newEndTime,
        bool _newActive
    ) external onlyOwner {
        require(_promotionId < promotions.length, "Invalid promotion ID");
        require(_newBonusPoints > 0, "Bonus points must be greater than zero");
        require(_newStartTime < _newEndTime, "Start time must be earlier than end time");

        promotions[_promotionId].name = _newName;
        promotions[_promotionId].bonusPoints = _newBonusPoints;
        promotions[_promotionId].startTime = _newStartTime;
        promotions[_promotionId].endTime = _newEndTime;
        promotions[_promotionId].active = _newActive;

        emit PromotionUpdated(_promotionId, _newName, _newBonusPoints, _newStartTime, _newEndTime, _newActive);
    }

    /**
     * @dev Get the number of promotions.
     * @return The number of promotions.
     */
    function getPromotionsCount() external view returns (uint256) {
        return promotions.length;
    }

    /**
     * @dev Check if a promotion is active and ongoing.
     * @param _promotionId The ID of the promotion.
     * @return A boolean indicating if the promotion is active and ongoing.
     */
    function isPromotionActive(uint256 _promotionId) external view returns (bool) {
        require(_promotionId < promotions.length, "Invalid promotion ID");

        Promotion memory promotion = promotions[_promotionId];
        uint256 currentTime = block.timestamp;

        return promotion.active && currentTime >= promotion.startTime && currentTime <= promotion.endTime;
    }

    /**
     * @dev Grant bonus points from a promotion to a user.
     * @param _promotionId The ID of the promotion.
     * @param _user The address of the user.
     */
    function grantPromotionBonus(uint256 _promotionId, address _user) external {
        require(isPromotionActive(_promotionId), "Promotion is not active or ongoing");

        Promotion memory promotion = promotions[_promotionId];

        pointsManagement.addPoints(_user, promotion.bonusPoints);
    }
}
