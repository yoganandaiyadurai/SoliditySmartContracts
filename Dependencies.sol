// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

abstract contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy 1");
        locked = true;
        _;
        locked = false;
    }
}