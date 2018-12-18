pragma solidity ^0.4.25;

import "./ERC721XToken.sol";

// Our own token based on ERC721x Token
contract ZombieCard is ERC721XToken {
    // map to monitor the supply of SE and LE cards
    // SE = Standard Edition
    // LE = Limited Edition
    mapping(uint => uint) internal tokenIdToIndividualSupply;

    // name method that returns the token name to wallets/exchanges
    function name() external view returns (string) {
        return "ZombieCard";
    }

    // Symbol of the token on wallets / marketplaces / exchanges
    function symbol() external view returns (string) {
        return "ZCX";
    }

    // indivisual supply tells the supply of the card
    function individualSupply(uint _tokenId) public view returns (uint) {
        return tokenIdToIndividualSupply(_tokenId);
    }

    // minting tokens for the cards
    function mintToken(uint _tokenId, uint _supply) public onlyOwner {
        require(!exists(_tokenId), "Error: Tried to mint duplicate token id");
        _mint(_tokenId, msg.sender, _supply);
        tokenIdToIndividualSupply[_tokenId] = _supply;
    }
}