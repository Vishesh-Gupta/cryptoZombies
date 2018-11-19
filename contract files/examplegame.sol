pragma solidity 0.4.24;

import "./ZB/ZBGameMode.sol";

contract ExampleGame is ZBGameMode  {

    // 1. Declare mapping here
    mapping (string => bool) internal bannedCards;

    // 2. Create constructor here
    constructor() public {
        bannedCards["Leash"] = true;
        bannedCards["Bulldozer"] = true;
        bannedCards["Lawnmower"] = true;
        bannedCards["Shopping Cart"] = true;
        bannedCards["Stapler"] = true;
        bannedCards["Nail Bomb"] = true;
        bannedCards["Goo Bottles"] = true;
        bannedCards["Molotov"] = true;
        bannedCards["Super Goo Serum"] = true;
        bannedCards["Junk Spear"] = true;
        bannedCards["Fire Extinguisher"] = true;
        bannedCards["Fresh Meat"] = true;
        bannedCards["Chainsaw"] = true;
        bannedCards["Bat"] = true;
        bannedCards["Whistle"] = true;
        bannedCards["Supply Drop"] = true;
        bannedCards["Goo Beaker"] = true;
        bannedCards["Zed Kit"] = true;
        bannedCards["Torch"] = true;
        bannedCards["Shovel"] = true;
        bannedCards["Boomstick"] = true;
        bannedCards["Tainted Goo"] = true;
        bannedCards["Corrupted Goo"] = true;
    }

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
