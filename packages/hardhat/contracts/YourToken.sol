pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract YourToken is ERC20, Ownable {
  constructor() ERC20("Crude", "CRD") {
    _mint(msg.sender , 1000000e18);
    _mint(address(this) , 1000000e18);
  }
}
