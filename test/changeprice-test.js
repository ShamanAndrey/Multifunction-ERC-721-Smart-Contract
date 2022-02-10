const { expect } = require("chai");
const { hexValue } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

describe("MultiERC721", function () {
  it("Check price then change price then test", async function () {
    const MyNFT = await ethers.getContractFactory("MyNFT");
    const myNFT = await MyNFT.deploy();
    await myNFT.deployed();

    const recipient = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266';

    let price = await myNFT.checkPrice();
    expect(price).to.equal('66000000000000000');

    const ChangePrice = await myNFT.changePrice('69000000000000000');
    await ChangePrice.wait();
    price = await myNFT.checkPrice();
    expect(price).to.equal('69000000000000000');
  });
});
