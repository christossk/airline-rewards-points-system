pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsConversion.sol";

contract PartnerIntegration is Ownable {
    // Instance of PointsConversion contract
    PointsConversion private pointsConversion;

    // Struct to store partner information
    struct Partner {
        uint256 id;
        string name;
        address partnerAddress;
        bool active;
    }

    // Array containing all partners
    Partner[] public partners;

    // Event emitted when a new partner is added
    event PartnerAdded(uint256 indexed partnerId, string name, address partnerAddress);

    // Event emitted when a partner is updated
    event PartnerUpdated(uint256 indexed partnerId, string newName, address newPartnerAddress, bool newActive);

    constructor(address _pointsConversionAddress) {
        pointsConversion = PointsConversion(_pointsConversionAddress);
    }

    /**
     * @dev Add a new partner.
     * @param _name The name of the partner.
     * @param _partnerAddress The wallet address of the partner.
     */
    function addPartner(string memory _name, address _partnerAddress) external onlyOwner {
        require(_partnerAddress != address(0), "Invalid partner address");

        uint256 partnerId = partners.length;

        Partner memory newPartner = Partner(partnerId, _name, _partnerAddress, true);

        partners.push(newPartner);

        emit PartnerAdded(partnerId, _name, _partnerAddress);
    }

    /**
     * @dev Update an existing partner.
     * @param _partnerId The ID of the partner to update.
     * @param _newName The new name for the partner.
     * @param _newPartnerAddress The new wallet address of the partner.
     * @param _newActive The new active status of the partner.
     */
    function updatePartner(uint256 _partnerId, string memory _newName, address _newPartnerAddress, bool _newActive) external onlyOwner {
        require(_partnerId < partners.length, "Invalid partner ID");
        require(_newPartnerAddress != address(0), "Invalid partner address");

        partners[_partnerId].name = _newName;
        partners[_partnerId].partnerAddress = _newPartnerAddress;
        partners[_partnerId].active = _newActive;

        emit PartnerUpdated(_partnerId, _newName, _newPartnerAddress, _newActive);
    }

    /**
     * @dev Redeem points for a user with a specific partner.
     * @param _userId The user ID of the user redeeming points.
     * @param _partnerId The ID of the partner where the user is redeeming points.
     * @param _points The number of points the user wants to redeem.
     */
    function redeemPoints(uint256 _userId, uint256 _partnerId, uint256 _points) external {
        require(_partnerId < partners.length, "Invalid partner ID");
        require(partners[_partnerId].active, "Partner is not active");

        pointsConversion.redeemPoints(_userId, _points);
    }
}
