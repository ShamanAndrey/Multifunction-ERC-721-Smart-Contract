const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MultiERC721", function () {
  it("Mint and transfer NFT", async function () {
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const myNFT = await MyNFT.deploy();
    await myNFT.deployed();

    const from = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266';
    const to = '0x70997970c51812dc3a010c7d01b50e0d17dc79c8';
    let balance = await myNFT.balanceOf(from);
    expect(balance).to.equal(0);

    const newlyMintedToken = await myNFT.payToMint(from,{value : ethers.utils.parseEther('0.066') });
    await newlyMintedToken.wait();
    balance = await myNFT.balanceOf(from);
    expect(balance).to.equal(1);

    const transfer = await myNFT.transferFrom(from,to,0);
    await transfer.wait();
    let balanceTo = await myNFT.balanceOf(to);
    expect(balanceTo).to.equal(1);
    balance = await myNFT.balanceOf(from);
    expect(balance).to.equal(0);

    const balanceOfSM = await myNFT.checkBalanceOfSM();
    expect(balanceOfSM).to.equal('66000000000000000');
  });
});
