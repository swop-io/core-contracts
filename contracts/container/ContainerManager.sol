pragma solidity ^0.5.8;

import "../auth/Owned.sol";

/**
    @title ContainerManager
    @dev Manages all the contract in the system
    @author karlptrck
 */
contract ContainerManager is Owned {
    mapping(string => address) private contracts;

    function addContract(string memory name, address contractAddress) public onlyOwner {
        require(contracts[name] == address(0));
        contracts[name] = contractAddress;
    }

    function getContract(string memory name) public view returns (address) {
        require(contracts[name] != address(0));
        return contracts[name];
    }
}
