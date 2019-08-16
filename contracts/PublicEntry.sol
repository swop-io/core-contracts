pragma solidity ^0.5.8;

import "./auth/Guard.sol";
import "./container/BaseContainer.sol";
import "./modules/SwopManager.sol";
import "./modules/auctions/Auctions.sol";

/**
    @title PublicEntry
    @dev All public calls that changes the state of blockchain should come through here
    @author karlptrck
 */
contract PublicEntry is BaseContainer, Guard {

    function postTicket(bytes32 refNo, uint256 amount, uint256 lowestAskAmount, bool forDirectBuy) external {
        SwopManager(getAddressOfSwopManager()).postTicket(refNo, amount, msg.sender, lowestAskAmount, forDirectBuy);
    }

    function buyTicket(bytes32 refNo) external payable {
        SwopManager(getAddressOfSwopManager()).buyTicket.value(msg.value)(refNo, msg.sender);
    }

    function completeTransaction(bytes32 refNo) external onlyAdmin {
       SwopManager(getAddressOfSwopManager()).completeTransaction(refNo);
    }

    function deposit(bytes32 refNo) external payable {
        Auctions(getAddressOfAuctions()).deposit.value(msg.value)(refNo, msg.sender);
    }

    function close
    (
        bytes32 refNo,
        uint256 topBidAmount,
        bytes32 nonce,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external
    {
        Auctions(getAddressOfAuctions()).close(refNo, msg.sender, topBidAmount, nonce, r, s, v);
    }

    function refund(bytes32 refNo) external {
        Auctions(getAddressOfAuctions()).refund(refNo, msg.sender);
    }
}