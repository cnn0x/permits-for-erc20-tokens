// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Permit.sol";

contract PermitToken is ERC20, Permit {
  constructor(
    string memory _name,
    string memory _symbl,
    uint256 _totalSupply
  ) ERC20(_name, _symbl) Permit(_name) {
    _mint(msg.sender, _totalSupply);
  }
}
