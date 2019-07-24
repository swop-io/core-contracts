pragma solidity ^0.5.8;

import "../database/FundsDB.sol";
import "../container/Contained.sol";
import "../lib/SafeMath.sol";

contract Funds is Contained {
    using SafeMath for uint256;
    event DisburseSeller(string refNo, address seller, uint256 amount);
    event DisburseAirline(string refNo, address airline, uint256 amount);

    FundsDB fundsDB;

    // .15 ETH = $50
    uint256 constant REBOOKING_FEE = 150000;

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
    onlyContract(CONTRACT_SWOP_MANAGER)
    {
        fundsDB.addLockedFunds(buyer, amount, refNo);
    }

    /**
     @dev Disburse the fund from the contract to seller and airline
     @param buyer address of the buyer
     @param airline address of the airline
     @param refNo unique reference number
     */
    function disburse
    (
        address buyer,
        address seller,
        address airline,
        uint256 amount,
        string calldata refNo
    )
    external
    onlyContract(CONTRACT_SWOP_MANAGER)
    {

        uint256 amountLessFee = amount.sub(REBOOKING_FEE);

        address payable newSeller = address(uint160(seller));
        newSeller.transfer(amountLessFee);
        emit DisburseSeller(refNo, seller, amountLessFee);

        address payable airlineReceiver = address(uint160(airline));
        airlineReceiver.transfer(REBOOKING_FEE);
        emit DisburseAirline(refNo, airlineReceiver, REBOOKING_FEE);

        fundsDB.releaseLockedFunds(buyer, refNo);
    }
}