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
    enum TicketState { POSTED, TRANSFER_IN_PROGRESS, SOLD }

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
        bytes32 refNo,
        uint256 amount,
        address payable seller,
        uint256 lowestAskAmount,
        bool forDirectBuy
    )
    external
    onlyContract(CONTRACT_SWOP_MANAGER)
    {
        commonDB.setAddressPayable(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'seller')), seller);
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'amount')), amount);
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'state')), uint(TicketState.POSTED));
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'lowestAskAmount')), lowestAskAmount);
        commonDB.setBoolean(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'forDirectBuy')), forDirectBuy);
    }

    /**
        @dev Get the ticket amount
        @param refNo unique reference number
     */
    function getTicketAmount(bytes32 refNo) external view
    returns (uint256) {
        return commonDB.getUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'amount')));
    }

    /**
        @dev Get the ticket seller
        @param refNo unique reference number
     */
    function getTicketSeller(bytes32 refNo) external view
    returns (address) {
        return commonDB.getAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'seller')));
    }

    /**
        @dev Set Ticket Buyer
        @param refNo unique reference number
     */
    function setTicketBuyer(bytes32 refNo, address buyer) external onlyContract(CONTRACT_SWOP_MANAGER) {
        commonDB.setAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'buyer')), buyer);
    }

    /**
        @dev UpdateTicketStatus
        @param refNo unique reference number
        @param value Ticket status
     */
    function updateTicketStatus(bytes32 refNo, uint256 value) external onlyContract(CONTRACT_SWOP_MANAGER) {
        commonDB.setUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'state')), value);
    }

    function getTicketStatus(bytes32 refNo) external view returns (uint256) {
        return commonDB.getUint(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'state')));
    }

    function getTicketBuyer(bytes32 refNo) external view returns (address) {
        return commonDB.getAddress(CONTRACT_NAME_TICKET_DB, keccak256(abi.encodePacked(refNo, 'buyer')));
    }

}