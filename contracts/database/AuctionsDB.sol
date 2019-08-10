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
    onlyContract(CONTRACT_AUCTIONS)
    {
        
        if(!isBidder(refNo, bidder)){
            commonDB.setAddressPayable(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'bidder')), bidder);
            commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')), depositAmount);
        }else{
            uint256 newTotal = getDepositedAmount(refNo, bidder).add(depositAmount);
            commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')), newTotal);
        }
    }

    function removeDeposit
    (
        string calldata refNo,
        address bidder
    ) 
    external 
    onlyContract(CONTRACT_AUCTIONS)
    {
         commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')), 0);
    }

    function setTopBidder
    (
        string calldata refNo,
        address bidder
    )
    external
    onlyContract(CONTRACT_AUCTIONS)
    {
        commonDB.setAddressPayable(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'topBidder')), bidder);
    }

    function updateAuctionState
    (
        string calldata refNo,
        uint8 state
    ) 
    external 
    onlyContract(CONTRACT_AUCTIONS)
    {
         commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'state')), state);
    }

    // GETTERS
    function isBidder(string calldata refNo, address bidder) public view
    returns(bool){
        return commonDB.getAddress(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo))) == address(0) ? false : true;
    }

    function getDepositedAmount(string calldata refNo, address bidder) public view 
    returns(uint256){
        return commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'depositAmount')));
    }

    function getAuctionState(string calldata refNo) external view 
    returns(uint8){
        retturn commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'state')));
    }

}