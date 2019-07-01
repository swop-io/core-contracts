pragma solidity ^0.5.8;
import "./EternalStorage.sol";

contract CommonDB is EternalStorage {

    function setBoolean(
        string calldata contractName,
        bytes32 key,
        bool value
    )
    external
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