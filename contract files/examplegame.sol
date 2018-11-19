pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract ExampleGame is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        // changePlayerCurrentGooVials — the number of vials the player currently has available for this round. The default starts at 1 when the match starts, and increases by 1 with every turn.
        // changePlayerCurrentGoo — the number of vials that are filled with goo in the current round. Defaults to be the same as the number of goo vials at the start of each turn.
        // changePlayerMaxGooVials — the max number of goo vials a player can have in the game. Default is 10.
        // changePlayerInitialCardsInHandCount — the number of cards the player is dealt when they start the match. Default is 3.
        // changePlayerMaxCardsInPlay — the maximum number of zombies a player can place on the field. Default is 6.
        // changePlayerMaxCardsInHand — the maximum number of cards a player can hold in their hand at one time. Default is 10
        // These functions all follow the same format as changePlayerDefense and accept two arguments: A Player enum, and a uint8.

        changes.changePlayerDefense(Player.Player1, 15);
        changes.changePlayerDefense(Player.Player2, 15);

        changes.changePlayerCurrentGooVials(Player.Player1, 3);
        changes.changePlayerCurrentGooVials(Player.Player2, 3);
        
        changes.changePlayerCurrentGoo(Player.Player1, 3);
        changes.changePlayerCurrentGoo(Player.Player2, 3);
        
        changes.changePlayerMaxGooVials(Player.Player1, 8);
        changes.changePlayerMaxGooVials(Player.Player2, 8);
    }
}
