pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

// 1. Change the name of this contract
contract Munchkin is ZBGameMode  {

    function beforeMatchStart(bytes serializedGameState) external {

        GameState memory gameState;
        gameState.init(serializedGameState);

        ZBSerializer.SerializedGameStateChanges memory changes;
        changes.init();

        // Custom game logic will go here

        changes.emit();

    }

}