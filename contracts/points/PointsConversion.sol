pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PointsManagement.sol";

contract PointsConversion is Ownable {
    // Instance of PointsManagement contract
    PointsManagement private pointsManagement;

    // Conversion rate from tokens to points (e.g. 1 token = 100 points)
    uint256 public conversionRate;

    // Event emitted when tokens are converted to points
    event TokensConverted(address indexed user, uint256 tokensAmount, uint256 pointsEarned);

    // Event emitted when the conversion rate is updated
    event ConversionRateUpdated(uint256 newConversionRate);

    constructor(address _pointsManagementAddress, uint256 _conversionRate) {
        pointsManagement = PointsManagement(_pointsManagementAddress);
        conversionRate = _conversionRate;
    }

    /**
     * @dev Convert tokens to points and add the points to the user's balance.
     * @param _user The wallet address of the user.
     * @param _tokensAmount The number of tokens to be converted to points.
     */
    function convertTokensToPoints(address _user, uint256 _tokensAmount) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(_tokensAmount > 0, "Tokens amount should be greater than zero");

        uint256 pointsEarned = _tokensAmount * conversionRate;
        pointsManagement.earnPoints(_user, pointsEarned);

        emit TokensConverted(_user, _tokensAmount, pointsEarned);
    }

    /**
     * @dev Update the conversion rate from tokens to points.
     * @param _newConversionRate The new conversion rate.
     */
    function updateConversionRate(uint256 _newConversionRate) external onlyOwner {
        require(_newConversionRate > 0, "Conversion rate should be greater than zero");

        conversionRate = _newConversionRate;

        emit ConversionRateUpdated(_newConversionRate);
    }
}
