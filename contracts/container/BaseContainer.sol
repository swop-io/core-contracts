pragma solidity ^0.5.8;

import "./ContainerManager.sol";

/**
    @title BaseContainer
    @dev Contains all getters of contract addresses in the system
    @author karlptrck
 */
contract BaseContainer is ContainerManager {
    string constant CONTRACT_SWOP_MANAGER = "SwopManager";
    string constant CONTRACT_FUNDS = "Funds";
    string constant CONTRACT_TICKET_DB = "TicketDB";
    string constant CONTRACT_FUNDS_DB = "FundsDB";

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
}