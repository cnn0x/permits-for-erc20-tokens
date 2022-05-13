const { ethers } = require("hardhat");
const { expect } = require("chai");
const { signERC2612Permit } = require("eth-permit");
const abi = require("../abi.json");

const senderAddress = "0x0385Ea2A02595C5cf106e9fE226B6984D6dc1702"; //test account 1
const spenderAddress = "0x7A3485CB062840A102348c1E91047A31FEf5A855"; //test account 2
const deployedContract = "0x82970797f759d05a3E15861f913382791d698281"; //deployed on rinkeby testnet

const wallet = new ethers.Wallet(
  process.env.PRIVATE_KEY,
  new ethers.providers.JsonRpcProvider(process.env.PROVIDER)
); //wallet instance

const contract = new ethers.Contract(deployedContract, abi, wallet);

describe("Permit in process...", () => {
  it("should permits", async () => {
    //the message is the ERC-712 typed structure, the message can be signed with signer._signTypedData() function.
    //In this case typed message signed with 3rd party lib
    const response = await signERC2612Permit(
      wallet, //wallet for sign the message
      deployedContract, //contract address will be needed for damain_separator hash
      senderAddress,
      spenderAddress
    );

    //permit function from the contract
    await contract.permit(
      senderAddress,
      spenderAddress,
      response.value, //allowance amount will be set to max
      response.nonce, //nonce is essential for prevent replay attacks
      response.deadline, //deadline  will be set to max
      response.v, //v, r, s will be used for recover signer
      response.r,
      response.s,
      { gasLimit: 50000 }
    );
  });

  it("should update allowance", async () => {
    const allowance = await contract.allowance(senderAddress, spenderAddress);

    //the application relies on max allowance
    const MAX =
      "115792089237316195423570985008687907853269984665640564039457584007913129639935";

    //the given allowance should be equal to max value
    expect(allowance.toString()).to.equal(MAX);
  });
});
