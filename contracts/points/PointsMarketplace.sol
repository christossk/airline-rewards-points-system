pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract PointsMarketplace is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Mapping from marketplace item ID to marketplace item information
    mapping(uint256 => MarketplaceItem) public marketplaceItems;

    // Marketplace item struct containing item information
    struct MarketplaceItem {
        uint256 id;
        string name;
        uint256 pointsRequired;
        uint256 stock;
        bool active;
    }

    // Counter to keep track of marketplace item IDs
    uint256 private marketplaceItemIdCounter;

    // Event emitted when a marketplace item is added
    event MarketplaceItemAdded(uint256 indexed itemId, string name, uint256 pointsRequired, uint256 stock);

    // Event emitted when a marketplace item is purchased
    event MarketplaceItemPurchased(address indexed user, uint256 indexed itemId);

    constructor(address _pointsManagementAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
    }

    /**
     * @dev Add a new marketplace item to the contract.
     * @param _name The name of the marketplace item.
     * @param _pointsRequired The number of points required to purchase the marketplace item.
     * @param _stock The stock of the marketplace item.
     */
    function addMarketplaceItem(string memory _name, uint256 _pointsRequired, uint256 _stock) external onlyOwner {
        require(_pointsRequired > 0, "Points required should be greater than zero");
        require(_stock > 0, "Stock should be greater than zero");

        marketplaceItemIdCounter++;

        MarketplaceItem memory newMarketplaceItem = MarketplaceItem(marketplaceItemIdCounter, _name, _pointsRequired, _stock, true);

        marketplaceItems[marketplaceItemIdCounter] = newMarketplaceItem;

        emit MarketplaceItemAdded(marketplaceItemIdCounter, _name, _pointsRequired, _stock);
    }

    /**
     * @dev Purchase a marketplace item using points.
     * @param _itemId The ID of the marketplace item to purchase.
     */
    function purchaseMarketplaceItem(uint256 _itemId) external {
        MarketplaceItem storage marketplaceItem = marketplaceItems[_itemId];

        require(marketplaceItem.active, "Marketplace item is not active");
        require(marketplaceItem.stock > 0, "Marketplace item is out of stock");
        require(pointsManagement.getPointsBalance(msg.sender) >= marketplaceItem.pointsRequired, "Insufficient points");

        pointsManagement.redeemPoints(msg.sender, marketplaceItem.pointsRequired);
        marketplaceItem.stock--;

        emit MarketplaceItemPurchased(msg.sender, _itemId);
    }

    /**
     * @dev Update the status of a marketplace item.
     * @param _itemId The ID of the marketplace item.
     * @param _active The new status of the marketplace item.
     */
    function updateMarketplaceItemStatus(uint256 _itemId, bool _active) external onlyOwner {
        require(marketplaceItems[_itemId].id != 0, "Marketplace item does not exist");

        marketplaceItems[_itemId].active = _active;
    }

    /**
     * @dev Update the stock of a marketplace item.
     * @param _itemId The ID of the marketplace item.
     * @param _newStock The new stock of the marketplace item.
     */
      function updateMarketplaceItemStock(uint256 _itemId, uint256 _newStock) external onlyOwner {
        require(marketplaceItems[_itemId].id != 0, "Marketplace item does not exist");

        marketplaceItems[_itemId].stock = _newStock;
    }
}
