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

    function postTicket(string calldata refNo, uint256 amount, bool forDirectBuy) external {
        SwopManager(getAddressOfSwopManager()).postTicket(refNo, amount, msg.sender, forDirectBuy);
    }

    function buyTicket(string calldata refNo) external payable {
        SwopManager(getAddressOfSwopManager()).buyTicket.value(msg.value)(refNo, msg.sender);
    }

    function completeTransaction(string calldata refNo) external onlyAdmin {
       SwopManager(getAddressOfSwopManager()).completeTransaction(refNo);
    }

    function directBuy
    (
        string calldata refNo,
        bytes32 r,
        bytes32 s,
        uint8 v
    )
    external payable
    {
        SwopManager(getAddressOfSwopManager()).directBuy.value(msg.value)(refNo, msg.sender, r, s, v);
    }

    function deposit(string calldata refNo) external payable {
        Auctions(getAddressOfAuctions()).deposit.value(msg.value)(refNo, msg.sender);
    }

    function close
    (
        string calldata refNo,
        address topBidAmount,
        uint8 nonce,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external
    {
        Auctions(getAddressOfAuctions()).close(refNo, msg.sender, topBidAmount, nonce, r, s, v);
    }

    function refund(string calldata refNo) external {
        Auctions(getAddressOfAuctions()).refund(refNo, msg.sender);
    }
}