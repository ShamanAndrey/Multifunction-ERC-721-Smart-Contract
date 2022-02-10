// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    // variable of cost for payToMint function
    uint256 public mintPrice = 0.066 ether;
    // variable for maximum supply
    uint256 public maxSupply = 10;
    // variable for maximum mints per user
    uint256 public maxMintAmount = 3;
    //Mapping of address to bool whitelist
    mapping(address => bool) public whitelisted;
    //Mapping of address to int to see if they reached mint limit
    mapping(address => uint16) public mintlimit;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyNFT", "NFT") {}

    function safeMint(address to, string memory uri) public onlyOwner {
        require(totalSupply() < maxSupply, "Maximum supply reached");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Change max mint amount
    function changeMaxMint(uint256 newMaxMint) public onlyOwner {
        maxMintAmount = newMaxMint;
    }

    // functions mint at set price, change set price and view set price
    function checkPrice() public view returns (uint256) {
        return (mintPrice);
    }

    function changePrice(uint256 setPrice) public onlyOwner {
        mintPrice = setPrice;
    }

    function payToMint(address to) public payable {
        require(whitelisted[msg.sender] == true, "user not whitelisted");
        require(
            mintlimit[msg.sender] < maxMintAmount,
            "user minted the maximum amount"
        );
        require(totalSupply() < maxSupply, "Maximum supply reached");
        require(msg.value >= mintPrice, "Not enough ether");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);
        mintlimit[msg.sender] += 1;
    }

    //change supply
    function changeMaxSupply(uint256 newMaxSupply) public onlyOwner {
        maxSupply = newMaxSupply;
    }

    //withdraw and check balance of the smart contract

    function checkBalanceOfSM() public view returns (uint256) {
        return (address(this).balance);
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    // Owener Whitelist add and remove
    function whiteListUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    function removeWhiteListUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }

    function removeArrayWhiteListUsers(address[] memory list) public onlyOwner {
        uint256 i = list.length - 1;
        while (i > 0) {
            whitelisted[list[i]] = false;
            i -= 1;
        }
    }

    function addArrayWhiteListUsers(address[] memory list) public onlyOwner {
        uint256 i = list.length - 1;
        while (i > 0) {
            whitelisted[list[i]] = true;
            i -= 1;
        }
    }
}
