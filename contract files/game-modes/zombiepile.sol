pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract ZombiePile is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        CardInstance[] memory player1Cards = new CardInstance[](gameState.playerStates[0].cardsInDeck.length);
        CardInstance[] memory player2Cards = new CardInstance[](gameState.playerStates[2].cardsInDeck.length);
        uint player1CardCount = 0;
        uint player2CardCount = 0;


        for (uint i = 0; i < gameState.playerStates.length; i++) {
            
            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                bool cardAlreadyInDeck = false;

                for (uint k = 0; k < cardCount; k++) {
                    if (keccak256(abi.encodePacked(newCards[k].mouldName)) == keccak256(abi.encodePacked(gameState.playerStates[i].cardsInDeck[j].mouldName))) {
                        cardAlreadyInDeck = true;
                    }
                }

                if (!cardAlreadyInDeck) {
                    newCards[cardCount] = gameState.playerStates[i].cardsInDeck[j];
                    cardCount++;
                }

            }

            changes.changePlayerCardsInDeck(Player(i), newCards, cardCount);
        }

        changes.emit();

    }

}
