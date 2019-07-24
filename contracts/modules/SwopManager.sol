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
    event TicketPosted(string refNo, uint256 amount, address seller, bool forDirectBuy);
    event FundsLocked(string refNo, address buyer);

    Funds funds;
    TicketDB ticketDB;

    uint256 public constant TICKET_STATE_FOR_SALE = 1;
    uint256 public constant TICKET_STATE_TRANSACTION_IN_PROGRESS = 2;
    uint256 public constant TICKET_STATE_SOLD = 3;
    address public receiver;

    /**
        @dev Sets all the required contracts
     */
    function init() external onlyOwner {
        funds = Funds(container.getContract(CONTRACT_FUNDS));
        ticketDB = TicketDB(container.getContract(CONTRACT_TICKET_DB));
    }

    function setReceiverAddress(address _receiver)
    external
    onlyOwner
    {
        receiver = _receiver;
    }

    /**
        @dev Adds ticket to list of for sale
        @param refNo unique reference number
        @param amount ticket amount
        @param seller address of the seller
        @param forDirectBuy option to set pre-defined buyer
     */
    function postTicket
    (
        string calldata refNo,
        uint256 amount,
        address payable seller,
        bool forDirectBuy
    )
    external
    onlyContained
    {
        ticketDB.addTicket(refNo, amount, seller, forDirectBuy);
        emit TicketPosted(refNo, amount, seller, forDirectBuy);
    }

    /**
        @dev Receives ether to be locked on Funds contract to buy the ticket
        @param refNo unique reference number
        @param buyer address of the buyer
     */
    function buyTicket(string memory refNo, address buyer)
    public payable
    onlyContained
    {
        uint256 amount = ticketDB.getTicketAmount(refNo);
        require(amount == msg.value, "Invalid amount");

        funds.lockFunds.value(msg.value)(buyer, amount, refNo);
        ticketDB.setTicketBuyer(refNo, buyer);
        ticketDB.updateTicketStatus(refNo, TICKET_STATE_TRANSACTION_IN_PROGRESS);

        emit FundsLocked(refNo, buyer);
    }

    /**
        @dev Complete the transaction by disbursing the amount to seller and airline 
        @param refNo unique reference number
     */
    function completeTransaction(string calldata refNo)
    external
    onlyContained
    {
        require(receiver != address(0), 'Airline Receiver Address is empty');
        uint256 amount = ticketDB.getTicketAmount(refNo);
        address seller = ticketDB.getTicketSeller(refNo);
        address buyer = ticketDB.getTicketBuyer(refNo);

        // Disburse the ether from Funds contract to the airline and seller
        funds.disburse(buyer, seller, receiver, amount, refNo);

        ticketDB.updateTicketStatus(refNo, TICKET_STATE_SOLD);

    }

    /**
        @dev Enables seller to pre-defined the buyer
        @param refNo unique reference number
        @param buyer address of the buyer
        @param r signature part
        @param s signature part
        @param v signature part
     */
    function directBuy
    (
        string calldata refNo,
        address buyer,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
    external
    payable
    onlyContained
    {
        bytes32 messageHash = keccak256(abi.encodePacked(refNo, buyer));

        bytes32 messageHash2 = keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32", messageHash
        ));

        address seller = ticketDB.getTicketSeller(refNo);
        require(ecrecover(messageHash2, v, r, s) == seller, "bad signature");

        this.buyTicket.value(msg.value)(refNo, buyer);
    }

}