pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Migrations is Ownable {
    // A contract version number to manage contract migrations
    uint256 public last_completed_migration;

    /**
     * @dev Set the completed migration version.
     * This function can only be called by the contract owner.
     * @param _completedVersion The version number to set as the completed migration.
     */
    function setCompleted(uint256 _completedVersion) public onlyOwner {
        last_completed_migration = _completedVersion;
    }

    /**
     * @dev Upgrade the Migrations contract to a new address.
     * This function can only be called by the contract owner.
     * @param _newAddress The address of the new Migrations contract.
     */
    function upgrade(address _newAddress) public onlyOwner {
        Migrations upgraded = Migrations(_newAddress);
        upgraded.setCompleted(last_completed_migration);
    }
}