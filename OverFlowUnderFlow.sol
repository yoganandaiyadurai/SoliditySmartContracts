//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract Counter {

    mapping(address => uint256) public balances;

    constructor() {
        balances[msg.sender] = 0;
    }

    function underflow_assembly() public pure returns(uint256) {
        uint256 n = 0;
        assembly {
            n := sub(n, 1)
        }
        // n now is equal to 115792089237316195423570985008687907853269984665640564039457584007913129639935
        return n;
    }

    function underflow_unchecked() public pure returns(uint256) {
        uint256 n = 0;
        unchecked {
            n--;
        }
        // n now is equal to 115792089237316195423570985008687907853269984665640564039457584007913129639935
        return n;
    }

    // reverts
    function no_underflow() public pure returns(uint256) {
        uint256 n = 0;
        n--;
        return n;
    }

    // reverts
    function balanceUnderflow() public {
        balances[msg.sender] -= 1;
    }

}

