pragma solidity ^0.5.8;

import "./CommonDB.sol";
import "../container/Contained.sol";

/**
    @title TicketDB
    @dev Stores all ticket states and information
    @author karlptrck
 */
contract TicketDB is Contained {

    CommonDB commonDB;
    string constant CONTRACT_NAME_TICKET_DB = "TicketDB";
    uint256 public constant TICKET_STATE_FOR_SALE = 1;
    uint256 public constant TICKET_STATE_TRANSACTION_IN_PROGRESS = 2;
    uint256 public constant TICKET_STATE_SOLD = 3;

    constructor(CommonDB _commonDB) public {
        commonDB = _commonDB;
    }

    /**
        @dev Stores the ticket details
        @param refNo unique reference number
        @param amount ticket amount
     */
    function addTicket
    (
        string calldata refNo,
        uint256 amount,
        address seller
    )
    external
    onlyContract(CONTRACT_SWOP_MANAGER)
    {
        // saves the address of the seller
        commonDB.setAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo)), seller);

        // saves the amount of the ticket
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo)), amount);

        // saves the status of the ticket
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo)), TICKET_STATE_FOR_SALE);
    }

    // TODO implement below functions
    // For more info: https://github.com/karlptrck/swop-contracts-mvp/issues/1

    // function getTicketAmount()

    // function getTicketSeller()

    // function updateTicketStatus()

    function getTicketStatus
    (
        string memory refNo
    )
    public view returns (uint256)
    {
        return commonDB.getUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo)));
    }

}