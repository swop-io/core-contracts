pragma solidity ^0.5.8;

import "./Funds.sol";
import "../container/Contained.sol";

contract Funds is Contained {

Funds funds;
//TicketDB ticketDB;

CommonDB commonDB;
string constant CONTRACT_NAME_TICKET_DB = "TicketDB";

/**
    @dev Sets all the required contracts
 */
function init() external onlyOwner {
    funds = Funds(container.getContract(CONTRACT_FUNDS));
    //ticketDB = TicketDB(container.getContract(CONTRACT_TICKET_DB));
}

/**
    @dev Locks amount on contract when ticket is bought
    @param buyer address of the buyer
    @param amount ticket amount
    @param refNo unique reference number
 */
function lockFunds
(
    address buyer,
    uint256 amount,
    string calldata refNo
)
external payable
onlyContained
{
    owner.transfer(amount);
    funds.addLockedFunds(buyer, amount, refNo);
}

}