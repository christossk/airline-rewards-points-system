pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserRegistration.sol";

contract CustomerSupport is Ownable {
    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Struct to store support ticket information
    struct SupportTicket {
        uint256 id;
        uint256 userId;
        string description;
        string response;
        bool resolved;
    }

    // Array containing all support tickets
    SupportTicket[] public supportTickets;

    // Event emitted when a new support ticket is created
    event SupportTicketCreated(uint256 indexed ticketId, uint256 userId, string description);

    // Event emitted when a support ticket is updated
    event SupportTicketUpdated(uint256 indexed ticketId, string response, bool resolved);

    constructor(address _userRegistrationAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Create a new support ticket.
     * @param _userId The user ID of the user creating the support ticket.
     * @param _description The description of the support ticket.
     */
    function createSupportTicket(uint256 _userId, string memory _description) external {
        require(userRegistration.isUserRegistered(_userId), "User is not registered");

        uint256 ticketId = supportTickets.length;

        SupportTicket memory newTicket = SupportTicket(ticketId, _userId, _description, "", false);

        supportTickets.push(newTicket);

        emit SupportTicketCreated(ticketId, _userId, _description);
    }

    /**
     * @dev Update an existing support ticket.
     * @param _ticketId The ID of the support ticket to update.
     * @param _response The response to the support ticket.
     * @param _resolved Whether the support ticket is resolved or not.
     */
    function updateSupportTicket(uint256 _ticketId, string memory _response, bool _resolved) external onlyOwner {
        require(_ticketId < supportTickets.length, "Invalid ticket ID");

        supportTickets[_ticketId].response = _response;
        supportTickets[_ticketId].resolved = _resolved;

        emit SupportTicketUpdated(_ticketId, _response, _resolved);
    }

    /**
     * @dev Get the number of support tickets.
     * @return The number of support tickets.
     */
    function getSupportTicketsCount() external view returns (uint256) {
        return supportTickets.length;
    }
}
