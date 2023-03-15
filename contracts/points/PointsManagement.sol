pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PointsManagement is Ownable {
    // Points struct containing points information for a user
    struct Points {
        uint256 earned;
        uint256 redeemed;
    }

    // Mapping from user's wallet address to points information
    mapping(address => Points) public userPoints;

    // Event emitted when points are earned
    event PointsEarned(address indexed user, uint256 amount);

    // Event emitted when points are redeemed
    event PointsRedeemed(address indexed user, uint256 amount);

    /**
     * @dev Add points to a user's earned points balance.
     * @param _user The wallet address of the user.
     * @param _amount The number of points to add.
     */
    function earnPoints(address _user, uint256 _amount) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(_amount > 0, "Amount should be greater than zero");

        userPoints[_user].earned += _amount;

        emit PointsEarned(_user, _amount);
    }

    /**
     * @dev Redeem points from a user's earned points balance.
     * @param _user The wallet address of the user.
     * @param _amount The number of points to redeem.
     */
    function redeemPoints(address _user, uint256 _amount) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(_amount > 0, "Amount should be greater than zero");
        require(userPoints[_user].earned >= _amount, "Insufficient earned points");

        userPoints[_user].earned -= _amount;
        userPoints[_user].redeemed += _amount;

        emit PointsRedeemed(_user, _amount);
    }

    /**
     * @dev Get the current points balance of a user.
     * @param _user The wallet address of the user.
     * @return The user's points balance.
     */
    function getPointsBalance(address _user) external view returns (uint256) {
        require(_user != address(0), "Invalid user address");

        return userPoints[_user].earned;
    }
}
