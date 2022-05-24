pragma solidity 0.8.14;

import "./ZB/ZBGameMode.sol";

contract Munchkin is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        for (uint i = 0; i < gameState.playerStates[i].length; i++) {
            CardInstance[] memory newCards = new CardInstance[](gameState.playerStates[i].cardsInDeck.length);
            uint cardCount = 0;

            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                if (isLegalCard(gameState.playerStates[i].cardsInDeck[j])) {
                    newCards[cardCount] = gameState.playerStates[i].cardsInDeck[j];
                    cardCount++;
                }
            }
        }

        changes.changePlayerCardsInDeck(Players(i), newCards, cardCount);
        changes.emitStateChange();
}

    function isLegalCard(CardInstance card) internal view returns(bool) {
        return (card.gooCost <= 2);
    }

}
