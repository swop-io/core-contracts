pragma solidity ^0.5.8;

import "../database/FundsDB.sol";
import "../container/Contained.sol";

contract Funds is Contained {

    event DisburseSeller(string refNo, address seller, uint256 amount);
    event DisburseAirline(string refNo, address airline, uint256 amount);

    FundsDB fundsDB;

    //CommonDB commonDB;
    uint constant SWOP_FEE = 150000000000000000;

    /**
        @dev Sets all the required contracts
     */
    function init() external onlyOwner {
        fundsDB = FundsDB(container.getContract(CONTRACT_FUNDS_DB));
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
        fundsDB.addLockedFunds(buyer, amount, refNo);
    }

    /**
     @dev Disburse the fund from the contract to seller and airline
     @param buyer address of the buyer
     @param seller address of the seller
     @param airline address of the airline
     @param refNo unique reference number
     */
    function disburse
    (
        address buyer,
        address payable seller,
        address payable airline,
        uint256 amount,
        string calldata refNo
    )
    external payable
    onlyContained
    {
        //Deduct transaction fee 
        uint256 amountLessFee = amount - SWOP_FEE;

        seller.transfer(amountLessFee);
        emit DisburseSeller(refNo, seller, amountLessFee);

        airline.transfer(SWOP_FEE);
        emit DisburseSeller(refNo, airline, SWOP_FEE);

        fundsDB.releaseLockedFunds(buyer, refNo);
    }
}