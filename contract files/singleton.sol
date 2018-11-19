pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract Singleton is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        for (uint i = 0; i < gameState.playerStates.length; i++) {
            CardInstance[] memory newCards = new CardInstance[](gameState.playerStates[i].cardsInDeck.length);
            uint cardCount = 0;

            for (uint j = 0; j < gameState.playerStates[i].cardsInDeck.length; j++) {
                // 2. Declare `bool` here
                
                // Placeholder — we'll implement this logic in the next chapter

                // 3. Change the condition of this `if` statement:
                if (isLegalCard(gameState.playerStates[i].cardsInDeck[j])) {
                    newCards[cardCount] = gameState.playerStates[i].cardsInDeck[j];
                    cardCount++;
                }
            }

            changes.changePlayerCardsInDeck(Player(i), newCards, cardCount);
        }

        changes.emit();

    }

    // 4. Delete this function:
    function isLegalCard(CardInstance card) internal view returns(bool) {
        return (card.gooCost <= 2);
    }

}
