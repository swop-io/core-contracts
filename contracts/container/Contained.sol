pragma solidity ^0.5.8;

import "../auth/Owned.sol";
import "./BaseContainer.sol";
import "./ContractNames.sol";

/**
    @title Contained
    @dev Wraps the contracts and functions from unauthorized access outside the system
    @author karlptrck
 */
contract Contained is Owned, ContractNames {
    BaseContainer public container;

    function setContainer(BaseContainer _container) public onlyOwner {
        container = _container;
    }

    modifier onlyContained(){
        require(address(container) != address(0), "No Container");
        require(msg.sender == address(container), "Only through Container");
        _;
    }

    modifier onlyContract(string memory name){
        require(address(container) != address(0), "No Container");
        address allowedContract = container.getContract(name);
        assert(allowedContract != address(0));
        require(msg.sender == allowedContract, "Only specific contract can access");
        _;
    }
}