// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Permit.sol";

//erc20 with permit functionality
contract PermitToken is Permit {
  ERC20 oldToken = ERC20(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8);

  constructor(
    string memory _name,
    string memory _symbl,
    uint256 _totalSupply
  ) ERC20(_name, _symbl) Permit(_name) {
    _mint(address(this), _totalSupply * 10**18);
  }

  function migrateBalance() public {
    address sender = msg.sender;
    uint256 oldBalance = oldToken.balanceOf(sender);

    if (oldBalance > 0) {
      oldToken.transferFrom(
        sender,
        0x000000000000000000000000000000000000dEaD,
        oldBalance
      );

      _transfer(address(this), sender, oldBalance);
    }
  }
}
