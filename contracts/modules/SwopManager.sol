pragma solidity ^0.5.8;

import "../database/TicketDB.sol";
import "./Funds.sol";

/**
    @title SwopManager
    @dev Manages all ticket states and transactions
    @author karlptrck
 */
contract SwopManager {
    event TicketPosted(string refNo, uint256 amount, address seller);
    event FundsLocked(string refNo, address buyer);

    Funds funds;
    TicketDB ticketDB;

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
    {
        // TODO implement these
        // uint256 amount = ticketDB.getTicketAmount(refNo);
        // require(amount == msg.value, "Invalid amount");

        // lock funds to Funds contract
        // funds.lockFunds(); not yet implemented

        // update ticket status to IN_PROGRESS
        // ticketDB.updateTicketStatus(IN_PROGRESS);

        emit FundsLocked(refNo, buyer);
    }

    function completeTransaction
    (
        string calldata refNo
    )
    external
    {
        // TODO compute the amount disbursment to airline and seller
        
        // TODO disburse the ether from Funds contract to the seller
        // funds.disburse(refNo);

    }
}