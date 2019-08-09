pragma solidity ^0.5.8;

import "./CommonDB.sol";
import "../container/Contained.sol";
import "../lib/SafeMath.sol";

contract AuctionsDB is Contained {
    using SafeMath for uint256;

    CommonDB commonDB;
    string constant CONTRACT_NAME_AUCTION_DB = "AuctionDB";

    constructor(CommonDB _commonDB) public {
        commonDB = _commonDB;
    }

    function addDeposit
    (
        string calldata refNo,
        uint256 depositAmount,
        address bidder,
    ) 
    external 
    {
        
        if(!isBidder(refNo, bidder)){
            commonDB.setAddressPayable(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo)), bidder);
            commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')), depositAmount);
        }else{
            uint256 newTotal = getDepositedAmount(refNo, bidder).add(depositAmount);
            commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')), newTotal);
        }
    }

    function isBidder
    (
        string calldata refNo, 
        address bidder
    ) 
    public 
    view returns(bool)
    {
        return commonDB.getAddress(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo))) == address(0) ? false : true;
    }

    function getDepositedAmount
    (
        string calldata refNo,
        address bidder
    )
    public
    view returns(uint256)
    {
        commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')));
    }
}