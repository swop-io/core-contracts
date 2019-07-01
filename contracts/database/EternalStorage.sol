pragma solidity ^0.5.8;

contract EternalStorage {
    mapping(bytes32 => bool) internal _bool;
    mapping(bytes32 => int) internal _int;
    mapping(bytes32 => uint) internal _uint;
    mapping(bytes32 => string) internal _string;
    mapping(bytes32 => address) internal _address;
    mapping(bytes32 => bytes) internal _bytes;
}