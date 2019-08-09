pragma solidity ^0.5.8;

import "./ContainerManager.sol";
import "./ContractNames.sol";

/**
    @title BaseContainer
    @dev Contains all getters of contract addresses in the system
    @author karlptrck
 */
contract BaseContainer is ContainerManager, ContractNames {

    function getAddressOfSwopManager() public view returns(address) {
        return getContract(CONTRACT_SWOP_MANAGER);
    }

    function getAddressOfFunds() public view returns(address) {
        return getContract(CONTRACT_FUNDS);
    }

    function getAddressOfTicketDB() public view returns(address) {
        return getContract(CONTRACT_TICKET_DB);
    }

    function getAddressOfFundsDB() public view returns(address) {
        return getContract(CONTRACT_FUNDS_DB);
    }

    function getAddressOfAuctions() public view returns(address) {
        return getContract(CONTRACT_AUCTIONS);
    }

    function getAddressOfAuctionsDB() public view returns(address) {
        return getContract(CONTRACT_AUCTIONS_DB);
    }
}