// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Permit.sol";

abstract contract PermitWrapper is Permit {
  function _permit(
    address tokenAddress,
    address owner,
    address spender,
    uint256 value,
    uint256 nonce,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public {
    permit(tokenAddress, owner, spender, value, nonce, deadline, v, r, s);
  }
}
