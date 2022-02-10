const { expect } = require("chai");
const { hexValue } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

describe("MultiERC721", function () {
  it("Mint, then change price then mint", async function () {
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const myNFT = await MyNFT.deploy();
    await myNFT.deployed();

    let price = await myNFT.checkPrice();
    expect(price).to.equal('66000000000000000');

    let ChangePrice = await myNFT.changePrice('69000000000000000');
    await ChangePrice.wait();
    price = await myNFT.checkPrice();
    expect(price).to.equal('69000000000000000');

    const from = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266';
    let balance = await myNFT.balanceOf(from);
    expect(balance).to.equal(0);

    let newlyMintedToken = await myNFT.payToMint(from,{value : ethers.utils.parseEther('0.069') });
    await newlyMintedToken.wait();
    balance = await myNFT.balanceOf(from);
    expect(balance).to.equal(1);

    ChangePrice = await myNFT.changePrice('79000000000000000');
    await ChangePrice.wait();
    price = await myNFT.checkPrice();
    expect(price).to.equal('79000000000000000');

    newlyMintedToken = await myNFT.payToMint(from,{value : ethers.utils.parseEther('0.079') });
    await newlyMintedToken.wait();
    balance = await myNFT.balanceOf(from);
    expect(balance).to.equal(2);
  });
});