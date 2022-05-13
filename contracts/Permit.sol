// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract Permit is ERC20 {
  mapping(address => uint256) public nonces; //tracking nonces is essential for prevent replay attacks

  //the hash of the function name, target function the signature for
  bytes32 public immutable PERMIT_TYPEHASH =
    keccak256(
      "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );
  bytes32 public immutable DOMAIN_SEPARATOR; //domain_sepataor makes signatures from different domains invalid

  constructor(string memory name) {
    //fetching chainId, will be 4 (rinkeby) for this contract
    uint256 chainId;
    assembly {
      chainId := chainid()
    }

    //hashing domain_separator with a few standart values like name, version, chainId, address of the contract
    DOMAIN_SEPARATOR = keccak256(
      abi.encode(
        keccak256(
          "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        ),
        keccak256(bytes(name)), //token name
        keccak256(bytes("1")), //version
        chainId, //chain id
        address(this) //address of the contract
      )
    );
  }

  // @title main function for for permits
  // @notice this function can be used for gasless approvals
  // @dev if the signature is valid, owner allowance for spender will be set to max uint256 value
  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 nonce,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public virtual {
    require(deadline >= block.timestamp, "EXPIRED_DEADLINE");

    bytes32 firstHash = keccak256(
      abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonce, deadline)
    );

    bytes32 hash = keccak256(
      abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, firstHash)
    );

    //this will prevent replay attacks
    //that means the signature can be used only once
    require(nonce == nonces[owner]++, "INVALID_NONCE");

    //signature can be splitted in solidity with assembly to get v, r, s values
    //in this case I accept v, r, s values as paramaters of permit function
    address signer = ecrecover(hash, v, r, s);

    require(
      signer != address(0) && signer == owner,
      "ERC20 : INVALID_SIGNATURE"
    );

    //approval is set to max, ~uint256(0) is returns max value, uint256(-1) can be also used
    _approve(owner, spender, ~uint256(0));
  }
}
