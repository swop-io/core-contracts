pragma solidity ^0.5.8;

import "./Funds.sol";
import "../container/Contained.sol";

contract Funds is Contained {

    event DisburseSeller(string refNo, address seller, amount);
    event DisburseAirline(string refNo, address airline, amount);

    Funds funds;

    CommonDB commonDB;
    uint constant SWOP_FEE = 150000000000000000;

    /**
        @dev Sets all the required contracts
     */
    function init() external onlyOwner {
        funds = Funds(container.getContract(CONTRACT_FUNDS));
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

    /**
     @dev Disburse the fund from the contract to seller and airline
     @param buyer address of the buyer
     @param refNo unique reference number
     */
    function disburse
    (
        address seller,
        address airline,
        uint256 amount,
        string calldata refNo
    )
    external payable
    onlyContained
    {
        //Deduct transaction fee 
        amountLessFee = amount - SWOP_FEE;

        seller.transfer(amountLessFee);
        emit DisburseSeller(refNo, seller, amountLessFee);

        airline.transfer(SWOP_FEE);
        emit DisburseSeller(refNo, airline, SWOP_FEE);

        funds.releaseLockedFunds(buyer, refNo);
    }
}