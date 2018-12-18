pragma solidity ^0.4.25;

import "./ERC721XToken.sol";

// Our own token based on ERC721x Token
contract ZombieCard is ERC721XToken {
    // name method that returns the token name to wallets/exchanges
    function name() external view returns (string) {
        return "ZombieCard";
    }

    // Symbol of the token on wallets / marketplaces / exchanges
    function symbol() external view returns (string) {
        return "ZCX";
    }
    
}