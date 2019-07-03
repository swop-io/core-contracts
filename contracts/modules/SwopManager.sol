pragma solidity ^0.5.8;

import "../database/TicketDB.sol";
import "./Funds.sol";
import "../container/Contained.sol";

/**
    @title SwopManager
    @dev Manages all ticket states and transactions
    @author karlptrck
 */
contract SwopManager is Contained {
    event TicketPosted(string refNo, uint256 amount, address seller);
    event FundsLocked(string refNo, address buyer);

    Funds funds;
    TicketDB ticketDB;

    uint256 public constant TICKET_STATE_FOR_SALE = 1;
    uint256 public constant TICKET_STATE_TRANSACTION_IN_PROGRESS = 2;
    uint256 public constant TICKET_STATE_SOLD = 3;

    /**
        @dev Sets all the required contracts
     */
    function init() external onlyOwner {
        funds = Funds(container.getContract(CONTRACT_FUNDS));
        ticketDB = TicketDB(container.getContract(CONTRACT_TICKET_DB));
    }

    /**
        @dev Adds ticket to list of for sale
        @param refNo unique reference number
        @param amount ticket amount
        @param seller address of the seller
     */
    function postTicket
    (
        string calldata refNo,
        uint256 amount,
        address seller
    )
    external 
    onlyContained
    {
        ticketDB.addTicket(refNo, amount, seller);
        emit TicketPosted(refNo, amount, seller);
    }

    /**
        @dev Receives ether to be locked on Funds contract to buy the ticket
        @param refNo unique reference number
        @param buyer address of the buyer
     */
    function buyTicket
    (
        string calldata refNo,
        address buyer
    )
    external payable
    onlyContained
    {
        uint256 amount = ticketDB.getTicketAmount(refNo);
        require(amount == msg.value, "Invalid amount");

        owner.transfer(amount);

        //lock funds to Funds contract
        funds.lockFunds();

        //update ticket status to IN_PROGRESS
        ticketDB.updateTicketStatus(refNo, TICKET_STATE_TRANSACTION_IN_PROGRESS);

        emit FundsLocked(refNo, buyer);
    }

    /**
        @dev Complete the transaction by disbursing the amount to seller and airline 
        @param refNo unique reference number
     */
    function completeTransaction
    (
        string calldata refNo
    )
    external
    onlyContained
    {
        uint256 amount = ticketDB.getTicketAmount(refNo);
        
        // Disburse the ether from Funds contract to the airline and seller
        funds.disburse(seller, airline, amount, refNo);

        //update ticket status to SOLD
        ticketDB.updateTicketStatus(refNo, TICKET_STATE_SOLD);

    }

}