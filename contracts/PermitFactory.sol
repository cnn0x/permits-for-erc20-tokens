// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PermitToken.sol";

contract PermitFactory {
  //creates ERC20 tokens that supports permit
  function createPermitToken(
    string memory name,
    string memory symbol,
    uint256 totalSupply
  ) public returns (address) {
    PermitToken token = new PermitToken(name, symbol, totalSupply);
    return address(token);
  }
}
