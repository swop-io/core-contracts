pragma solidity ^0.5.8;

import "../../lib/SafeMath.sol";
import "../../container/Contained.sol";

contract AuctionsEscrow is Contained {
    using SafeMath for uint256;

    event Deposited(address indexed payee, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 weiAmount);

    mapping(address => uint256) private _deposits;

    function depositsOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }

    /**
     * @dev Stores the sent amount as credit to be withdrawn.
     * @param payee The destination address of the funds.
     */
    function deposit(address payee) public onlyContract(CONTRACT_AUCTIONS) payable {
        uint256 amount = msg.value;
        _deposits[payee] = _deposits[payee].add(amount);

        emit Deposited(payee, amount);
    }

    /**
     * @dev Withdraw accumulated balance for a payee.
     * @param payee The address whose funds will be withdrawn and transferred to.
     */
    function withdraw(address payable payee, uint256 payment) public onlyContract(CONTRACT_AUCTIONS) {

        _deposits[payee] = _deposits[payee].sub(payment);

        payee.transfer(payment);

        emit Withdrawn(payee, payment);
    }
}