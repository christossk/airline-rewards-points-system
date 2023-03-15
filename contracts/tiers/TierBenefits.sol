pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./TierManagement.sol";

contract TierBenefits is Ownable {
    // Instance of TierManagement contract
    TierManagement private tierManagement;

    // Mapping from tier ID to a list of benefits
    mapping(uint256 => string[]) private tierBenefits;

    // Event emitted when a benefit is added to a tier
    event BenefitAdded(uint256 indexed tierId, string benefit);

    // Event emitted when a benefit is removed from a tier
    event BenefitRemoved(uint256 indexed tierId, string benefit);

    constructor(address _tierManagementAddress) {
        tierManagement = TierManagement(_tierManagementAddress);
    }

    /**
     * @dev Add a benefit to a specific tier.
     * @param _tierId The ID of the tier to add the benefit to.
     * @param _benefit The benefit to add to the tier.
     */
    function addTierBenefit(uint256 _tierId, string memory _benefit) external onlyOwner {
        require(bytes(_benefit).length > 0, "Benefit cannot be empty");

        tierBenefits[_tierId].push(_benefit);

        emit BenefitAdded(_tierId, _benefit);
    }

    /**
     * @dev Remove a benefit from a specific tier.
     * @param _tierId The ID of the tier to remove the benefit from.
     * @param _index The index of the benefit to remove from the tier.
     */
    function removeTierBenefit(uint256 _tierId, uint256 _index) external onlyOwner {
        require(_index < tierBenefits[_tierId].length, "Invalid benefit index");

        string memory removedBenefit = tierBenefits[_tierId][_index];

        // Move the last benefit in the list to the index of the removed benefit
        tierBenefits[_tierId][_index] = tierBenefits[_tierId][tierBenefits[_tierId].length - 1];
        // Remove the last benefit in the list
        tierBenefits[_tierId].pop();

        emit BenefitRemoved(_tierId, removedBenefit);
    }

    /**
     * @dev Get the benefits associated with a specific tier.
     * @param _tierId The ID of the tier to retrieve benefits for.
     * @return benefits An array containing the benefits of the specified tier.
     */
    function getTierBenefits(uint256 _tierId) external view returns (string[] memory benefits) {
        return tierBenefits[_tierId];
    }

    /**
     * @dev Get the benefits associated with a user's current tier.
     * @param _user The wallet address of the user.
     * @return benefits An array containing the benefits of the user's current tier.
     */
    function getUserBenefits(address _user) external view returns (string[] memory benefits) {
        TierManagement.Tier memory userTier = tierManagement.getUserTier(_user);
        return getTierBenefits(userTier.id);
    }
}
