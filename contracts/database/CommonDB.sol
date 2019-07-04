pragma solidity ^0.5.8;
import "./EternalStorage.sol";
import "../container/Contained.sol";

/**
    @title Common Eternal Storage
    @dev Functions that update the states should only be accessible by contracts in the system
    @author karlptrck
 */
contract CommonDB is EternalStorage, Contained {

    function setBoolean(
        string calldata contractName,
        bytes32 key,
        bool value
    )
    external
    onlyContract(contractName)
    {
        _bool[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function getBoolean(
        string memory contractName,
        bytes32 key
    )
    public view returns(bool)
    {
        return _bool[keccak256(abi.encodePacked(contractName, key))];
    }

    function setInt(
        string calldata contractName,
        bytes32 key,
        int value
    )
    external
    onlyContract(contractName)
    {
        _int[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function getInt(
        string memory contractName,
        bytes32 key
    )
    public view returns(int256)
    {
        return _int[keccak256(abi.encodePacked(contractName, key))];
    }

    function setUint(
        string calldata contractName,
        bytes32 key,
        uint256 value
    )
    external
    onlyContract(contractName)
    {
        _uint[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function getUint(
        string memory contractName,
        bytes32 key
    )
    public view returns(uint256)
    {
        return _uint[keccak256(abi.encodePacked(contractName, key))];
    }

    function setAddress(
        string calldata contractName,
        bytes32 key,
        address value
    )
    external
    onlyContract(contractName)
    {
        _address[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function setAddressPayable(
        string calldata contractName,
        bytes32 key,
        address payable value
    )
    external
    onlyContract(contractName)
    {
        _address[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function getAddress(
        string memory contractName,
        bytes32 key
    )
    public view returns(address)
    {
        return _address[keccak256(abi.encodePacked(contractName, key))];
    }

    function setString(
        string calldata contractName,
        bytes32 key,
        string calldata value
    )
    external
    onlyContract(contractName)
    {
        _string[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function getString(
        string memory contractName,
        bytes32 key
    )
    public view returns(string memory)
    {
        return _string[keccak256(abi.encodePacked(contractName, key))];
    }

    function setBytes(
        string calldata contractName,
        bytes32 key,
        bytes calldata value
    )
    external
    onlyContract(contractName)
    {
        _bytes[keccak256(abi.encodePacked(contractName, key))] = value;
    }

    function getBytes(
        string memory contractName,
        bytes32 key
    )
    public view returns(bytes memory)
    {
        return _bytes[keccak256(abi.encodePacked(contractName, key))];
    }
}