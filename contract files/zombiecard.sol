pragma solidity ^0.4.25;

import "./ERC721XToken.sol";

// Our own token based on ERC721x Token
contract ZombieCard is ERC721XToken {
    // map to monitor the supply of SE and LE cards
    // SE = Standard Edition
    // LE = Limited Edition
    mapping(uint => uint) internal tokenIdToIndividualSupply;
    mapping(uint => uint) internal nftTokenIdToMouldId;
    uint nftTokenIdIndex = 1000000;

    event TokenAwarded(uint indexed tokenId, address claimer, uint amount);

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

    // awarding tokens to _to from the msg.sender
    function awardToken(uint _tokenId, address _to, uint _amount) public onlyOwner {
        require(exists(_tokenId), "TokenID has not been minted");
        if (individualSupply[_tokenId] > 0) {
            require(_amount <= balanceOf(msg.sender, _tokenId), "Quantity greater than remaining cards");
            // _updateTokenBalance is from ERC721XToken
            _updateTokenBalance(msg.sender, _tokenId, _amount, ObjectLib.Operations.SUB);
        }
        _updateTokenBalance(_to, _tokenId, _amount, ObjectLib.Operations.ADD);
        emit TokenAwarded(_tokenId, _to, _amount);
    }

    // coverting Fungible Tokens to Non Fungible Tokens
    function convertToNFT(uint _tokenId, uint _amount) public {
        require(tokenType[_tokenId] == FT);
        require(_amount <= balanceOf(msg.sender, _tokenId), "You do not own enough tokens");
        
        _updateTokenBalance(msg.sender, _tokenId, _amount, ObjectLib.Operations.SUB);
        for (uint i = 0; i < _amount; i++) {
            // NFT version of mint, the contract emits an event 
            /*
             * ```sol
             *      emit Transfer(address(this), _to, _tokenId)
             * ```
             * so that the user can get the ID to the new NFt token they received
             */
             _mint(nftTokenIdIndex, msg.sender);
            nftTokenIdToMouldId[nftTokenIdIndex] = _tokenId;
            nftTokenIdIndex++;
        }
    }

}

