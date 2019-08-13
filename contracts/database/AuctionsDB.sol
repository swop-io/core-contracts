pragma solidity ^0.5.8;

import "./CommonDB.sol";
import "../container/Contained.sol";
import "../lib/SafeMath.sol";

contract AuctionsDB is Contained {
    using SafeMath for uint256;

    CommonDB commonDB;
    string constant CONTRACT_NAME_AUCTION_DB = "AuctionsDB";

    constructor(CommonDB _commonDB) public {
        commonDB = _commonDB;
    }

    function addDeposit
    (
        bytes32 refNo,
        uint256 depositAmount,
        address payable bidder
    )
    external
    onlyContract(CONTRACT_AUCTIONS)
    {
        if(!isBidder(refNo, bidder)){
            commonDB.setAddressPayable(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'bidder')), bidder);
            commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'depositAmount')), depositAmount);
        }else{
            uint256 newTotal = getDepositedAmount(refNo, bidder).add(depositAmount);
            commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'depositAmount')), newTotal);
        }
    }

    function removeDeposit
    (
        bytes32 refNo,
        address bidder
    )
    external
    onlyContract(CONTRACT_AUCTIONS)
    {
         commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'depositAmount')), 0);
    }

    function setTopBidder
    (
        bytes32 refNo,
        address bidder
    )
    external
    onlyContract(CONTRACT_AUCTIONS)
    {
        commonDB.setAddress(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'topBidder')), bidder);
    }

    function updateAuctionState
    (
        bytes32 refNo,
        uint8 state
    )
    external
    onlyContract(CONTRACT_AUCTIONS)
    {
         commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'state')), state);
    }

    // GETTERS
    function isBidder(bytes32 refNo, address bidder) public view
    returns(bool){
        return commonDB.getAddress(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'bidder'))) == address(0) ? false : true;
    }

    function getDepositedAmount(bytes32 refNo, address bidder) public view
    returns(uint256){
        return commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'depositAmount')));
    }

    function getAuctionState(bytes32 refNo) external view
    returns(uint8){
        return uint8(commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'state'))));
    }

    function getTopBidder(bytes32 refNo) external view
    returns(address){
        return commonDB.getAddress(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'topBidder')));
    }
}