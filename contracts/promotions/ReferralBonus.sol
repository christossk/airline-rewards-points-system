pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";
import "./UserRegistration.sol";

contract ReferralBonus is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Mapping to store referral bonus for each referrer
    mapping(address => uint256) public referralBonuses;

    // Event emitted when a referral bonus is granted
    event ReferralBonusGranted(address indexed referrer, address indexed referee, uint256 bonus);

    constructor(address _pointsManagementAddress, address _userRegistrationAddress) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Set the referral bonus amount for a referrer.
     * @param _referrer The address of the referrer.
     * @param _bonus The referral bonus amount.
     */
    function setReferralBonus(address _referrer, uint256 _bonus) external onlyOwner {
        require(userRegistration.isUserRegistered(_referrer), "Referrer must be a registered user");
        referralBonuses[_referrer] = _bonus;
    }

    /**
     * @dev Grant referral bonus points to a referrer when a new user registers using their referral code.
     * @param _referrer The address of the referrer.
     * @param _referee The address of the new user (referee).
     */
    function grantReferralBonus(address _referrer, address _referee) external {
        require(userRegistration.isUserRegistered(_referrer), "Referrer must be a registered user");
        require(userRegistration.isUserRegistered(_referee), "Referee must be a registered user");
        require(_referrer != _referee, "Referrer and referee cannot be the same address");

        uint256 bonus = referralBonuses[_referrer];
        require(bonus > 0, "Referrer does not have a referral bonus set");

        pointsManagement.addPoints(_referrer, bonus);
        emit ReferralBonusGranted(_referrer, _referee, bonus);
    }
}
