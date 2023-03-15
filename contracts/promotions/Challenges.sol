pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserRegistration.sol";

contract Challenges is Ownable {
    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Struct to store challenge information
    struct Challenge {
        uint256 id;
        string name;
        string description;
        uint256 points;
        uint256 startTime;
        uint256 endTime;
    }

    // Array containing all challenges
    Challenge[] private challenges;

    // Mapping of user ID to an array of completed challenge IDs
    mapping(uint256 => uint256[]) private completedChallenges;

    constructor(address _userRegistrationAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Create a new challenge.
     * This function can only be called by the contract owner.
     * @param _name The name of the challenge.
     * @param _description A description of the challenge.
     * @param _points The points to be awarded for completing the challenge.
     * @param _startTime The start time of the challenge.
     * @param _endTime The end time of the challenge.
     */
    function createChallenge(
        string memory _name,
        string memory _description,
        uint256 _points,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyOwner {
        require(_endTime > _startTime, "End time must be greater than start time");

        Challenge memory newChallenge = Challenge(challenges.length, _name, _description, _points, _startTime, _endTime);
        challenges.push(newChallenge);
    }

    /**
     * @dev Complete a challenge for a user.
     * This function can only be called by the contract owner.
     * @param _userId The user ID of the user.
     * @param _challengeId The ID of the challenge.
     */
    function completeChallenge(uint256 _userId, uint256 _challengeId) external onlyOwner {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");
        require(_challengeId < challenges.length, "Invalid challenge ID");

        Challenge memory challenge = challenges[_challengeId];
        require(block.timestamp >= challenge.startTime && block.timestamp <= challenge.endTime, "Challenge is not active");

        completedChallenges[_userId].push(_challengeId);
    }

    /**
     * @dev Get the completed challenges for a user.
     * @param _userId The user ID of the user.
     * @return An array of the user's completed challenge IDs.
     */
    function getCompletedChallenges(uint256 _userId) external view returns (uint256[] memory) {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");
        return completedChallenges[_userId];
    }
}
