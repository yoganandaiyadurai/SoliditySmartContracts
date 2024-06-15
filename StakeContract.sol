// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error StakeContract_TrasferFailer();

contract StakeContract {
   mapping(address=>uint) public s_balances;
   function stake(uint amount, address token) external returns (bool success){
  
    s_balances[msg.sender] = s_balances[msg.sender] + amount;
    success = IERC20(token).transferFrom(msg.sender, address(this), amount);
    if(!success) revert StakeContract_TrasferFailer();
    return success;
   }
}
