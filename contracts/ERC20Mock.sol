// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//erc20 without permit functionality
contract ERC20Token is ERC20 {
  constructor(
    string memory _name,
    string memory _symbl,
    uint256 _totalSupply
  ) ERC20(_name, _symbl) {
    _mint(msg.sender, _totalSupply * 10**18);
  }
}
