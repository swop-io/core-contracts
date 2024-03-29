pragma solidity ^0.5.8;

import "../../container/Contained.sol";
import "../../database/AuctionsDB.sol";
import "../../database/TicketDB.sol";
import "./AuctionsEscrow.sol";

contract Auctions is Contained {

    enum AuctionState { ACTIVE, CANCELLED, CLOSED, COMPLETED }

    event NewDeposit(bytes32 refNo, uint256 amount, address bidder);
    event AuctionClosed(bytes32 refNo, address topBidder);
    event Refunded(bytes32 refNo, uint256 amount, address bidder);

    AuctionsDB auctionsDB;
    TicketDB ticketDB;
    AuctionState auctionState;
    AuctionsEscrow escrow;

    /**
        @dev Sets all the required contracts
     */
    function init() external onlyOwner {
        auctionsDB = AuctionsDB(container.getContract(CONTRACT_AUCTIONS_DB));
        ticketDB = TicketDB(container.getContract(CONTRACT_TICKET_DB));
        escrow = AuctionsEscrow(container.getContract(CONTRACT_AUCTIONS_ESCROW));
    }

    function deposit
    (
        bytes32 refNo,
        address payable bidder
    )
    external payable
    onlyContained
    {
        require(auctionsDB.getAuctionState(refNo) == uint(AuctionState.ACTIVE), "Auction not active");

        escrow.deposit.value(msg.value)(bidder);
        auctionsDB.addDeposit(refNo, msg.value, bidder);

        emit NewDeposit(refNo, msg.value, bidder);
    }

    function close
    (
        bytes32 refNo,
        address caller,
        uint256 topBidAmount,
        bytes32 nonce,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
    external
    onlyContained
    {
        require(auctionsDB.getAuctionState(refNo) == uint(AuctionState.ACTIVE), "Auction not active");
        require(ticketDB.getTicketSeller(refNo) == caller, "Should be only close by seller");

        bytes32 messageHash = keccak256(abi.encodePacked(refNo, topBidAmount, nonce));

        bytes32 messageHash2 = keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32", messageHash
        ));

        address payable topBidder = address(uint160(ecrecover(messageHash2, v, r, s)));
        auctionsDB.setTopBidder(refNo, topBidder);
        auctionsDB.updateAuctionState(refNo, uint8(AuctionState.CLOSED));
        emit AuctionClosed(refNo, topBidder);
    }

    function refund
    (
        bytes32 refNo,
        address payable bidder
    )
    external
    onlyContained
    {
        require(auctionsDB.getAuctionState(refNo) != uint(AuctionState.ACTIVE), "Not able to refund when auction is active");
        require(auctionsDB.isBidder(refNo, bidder), "Not authorized");

        uint256 amount = auctionsDB.getDepositedAmount(refNo, bidder);
        require(amount > 0, "No amount to refund");

        escrow.withdraw(bidder, amount);

        auctionsDB.removeDeposit(refNo, bidder);
        emit Refunded(refNo, amount, bidder);
    }
}