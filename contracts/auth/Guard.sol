pragma solidity ^0.5.8;

/**
    @title Guard
    @dev Access control guard based on roles
    @author karlptrck
 */
contract Guard {
    string constant internal ADMIN_ROLE = "admin";
    string constant internal SELLER_ROLE = "seller";
    string constant internal BUYER_ROLE = "buyer";


    // TODO Implement roles from openzeppelin

    modifier onlySuperAdmin(){
        assert(msg.sender != address(0));
        // TODO check role
        _;
    }

    modifier onlyAdmin(){
        assert(msg.sender != address(0));
        // TODO check role
        _;
    }

    modifier onlySeller(){
        assert(msg.sender != address(0));
        // TODO check role
        _;
    }

    modifier onlyBuyer(){
        assert(msg.sender != address(0));
        // TODO check role
        _;
    }

}