pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserRegistration.sol";

contract FraudDetection is Ownable {
    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Struct to store fraud report information
    struct FraudReport {
        uint256 id;
        uint256 userId;
        string description;
        bool resolved;
    }

    // Array containing all fraud reports
    FraudReport[] private fraudReports;

    constructor(address _userRegistrationAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Create a new fraud report.
     * This function can only be called by the contract owner.
     * @param _userId The ID of the user associated with the fraud report.
     * @param _description A description of the fraud report.
     */
    function createFraudReport(uint256 _userId, string memory _description) external onlyOwner {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");

        FraudReport memory newReport = FraudReport(fraudReports.length, _userId, _description, false);
        fraudReports.push(newReport);
    }

    /**
     * @dev Set the resolved status of a fraud report.
     * This function can only be called by the contract owner.
     * @param _reportId The ID of the fraud report.
     * @param _resolved The new resolved status of the fraud report.
     */
    function setResolvedStatus(uint256 _reportId, bool _resolved) external onlyOwner {
        require(_reportId < fraudReports.length, "Invalid report ID");

        fraudReports[_reportId].resolved = _resolved;
    }

    /**
     * @dev Get the details of a fraud report.
     * @param _reportId The ID of the fraud report.
     * @return userId, description, resolved
     */
    function getFraudReportDetails(uint256 _reportId)
        external
        view
        returns (
            uint256 userId,
            string memory description,
            bool resolved
        )
    {
        require(_reportId < fraudReports.length, "Invalid report ID");

        FraudReport memory report = fraudReports[_reportId];
        return (report.userId, report.description, report.resolved);
    }
}
