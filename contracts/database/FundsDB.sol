pragma solidity ^0.5.8;

import "./CommonDB.sol";
import "../container/Contained.sol";

/**
    @title FundsDB
    @dev Stores all the fund details that are locked in the Funds contract
    @author karlptrck
 */
contract FundsDB is Contained {

    CommonDB commonDB;
    string constant CONTRACT_NAME_FUNDS_DB = "FundsDB";

    constructor(CommonDB _commonDB) public {
        commonDB = _commonDB;
    }

    /**
        @dev Stores the locked funds
        @param amount amount that was locked
        @param buyer address of the owner of fund
        @param refNo unique reference number
     */
    function addLockedFunds
    (
        address buyer,
        uint256 amount,
        bytes32 refNo
    )
    external
    onlyContract(CONTRACT_FUNDS)
    {
        // save the amount of locked funds
        commonDB.setUint(CONTRACT_FUNDS_DB, keccak256(abi.encodePacked(buyer, refNo)), amount);

        // set fund status to locked
        commonDB.setBoolean(CONTRACT_FUNDS_DB, keccak256(abi.encodePacked(buyer, refNo)), true);
    }

    /**
        @dev Releases the locked funds
        @param buyer address of the owner of fund
        @param refNo unique reference number
     */
    function releaseLockedFunds
    (
        address buyer,
        bytes32 refNo
    )
    external
    onlyContract(CONTRACT_FUNDS)
    {
        commonDB.setBoolean(CONTRACT_FUNDS_DB, keccak256(abi.encodePacked(buyer, refNo)), false);
    }

    /**
        @dev Gets the locked amount
        @param buyer address of the owner of fund
        @param refNo unique reference number
        @return amount
     */
    function getLockedAmount
    (
        address buyer,
        bytes32 refNo
    )
    external view returns (uint256)
    {
        return commonDB.getUint(CONTRACT_FUNDS_DB, keccak256(abi.encodePacked(buyer, refNo)));
    }
}