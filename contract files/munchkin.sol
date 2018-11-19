pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract Munchkin is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        for (uint i = 0; i < gameState.playerStates[i].cardsInDeck.length; i++) {
            CardInstance[] memory newCards = new CardInstance[](gameState.playerStates[i].cardsInDeck.length);
            uint cardCount = 0;

            for (uint j = 0; j < gameState.playerStates[i].cardsInDecl.length; j++){
                if (isLegalCard(gameState.playerStates[i].cardsInDeck[j])) {
                    newCards[cardCount] = gameState.playerState[i].cardsInDeck[j];
                    cardCount++;
                }
            }
        }

        changes.changesPlayerCardsInDeck(Players(i), newCards, cardCount);

        changes.emit();

    }

    
    function isLegalCard(CardInstance card) internal view returns (bool) {
        
    }

}
