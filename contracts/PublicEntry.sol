pragma solidity ^0.5.8;

import "./auth/Guard.sol";
import "./container/BaseContainer.sol";
import "./modules/SwopManager.sol";

/**
    @title PublicEntry
    @dev All public calls that changes the state of blockchain should come through here
    @author karlptrck
 */
contract PublicEntry is BaseContainer, Guard {

    function postTicket
    (
        string calldata refNo,
        uint256 amount,
        address seller
    )
    external
    {
        SwopManager(getAddressOfSwopManager()).postTicket(refNo, amount, seller);
    }

    function buyTicket
    (
        string calldata refNo,
        address buyer
    )
    external payable
    {
        SwopManager(getAddressOfSwopManager()).buyTicket(refNo, buyer);
    }

    function completeTransaction
    (
        string calldata refNo
    )
    external onlyAdmin
    {
       SwopManager(getAddressOfSwopManager()).completeTransaction(refNo);
    }

}