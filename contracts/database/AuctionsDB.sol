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
        string calldata refNo,
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
        string calldata refNo,
        address bidder
    ) 
    external
    onlyContract(CONTRACT_AUCTIONS)
    {
         commonDB.setUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'depositAmount')), 0);
    }

    function setTopBidder
    (
        string calldata refNo,
        address payable bidder
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
    function isBidder(string memory refNo, address bidder) public view
    returns(bool){
        return commonDB.getAddress(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'bidder'))) == address(0) ? false : true;
    }

    function getDepositedAmount(string memory refNo, address bidder) public view
    returns(uint256){
        return commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, bidder, 'depositAmount')));
    }

    function getAuctionState(string calldata refNo) external view
    returns(uint8){
        return uint8(commonDB.getUint(CONTRACT_NAME_AUCTION_DB, keccak256(abi.encodePacked(refNo, 'state'))));
    }

}