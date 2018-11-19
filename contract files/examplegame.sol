pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract ExampleGame is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

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
