// This file is here for your reference, but doesn't contain all the imports necessary
// to compile. You can find a repo with all the final files at:
// https://github.com/loomnetwork/zb_game_mode

pragma solidity ^0.8.14;

import "./ZBEnum.sol";
import "./ZBGameMode.sol";


library ZBSerializer {
    using SerialityBinaryStream for SerialityBinaryStream.BinaryStream;
    uint constant defaultSerializedGameStateChangesBufferSize = 512;
    uint constant defaultSerializedCustomUiBufferSize = 512;

    event GameStateChanges (
        bytes serializedChanges
    );

    struct SerializedGameStateChanges {
        SerialityBinaryStream.BinaryStream stream;
    }

    struct SerializedCustomUi {
        SerialityBinaryStream.BinaryStream stream;
    }

    // GameState deserialization

    function init(ZBGameMode.GameState memory self, bytes serializedGameState) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = SerialityBinaryStream.BinaryStream(serializedGameState, serializedGameState.length);

        self.id = stream.readInt64();
        self.currentPlayerIndex = stream.readUint8();

        self.playerStates = new ZBGameMode.PlayerState[](2);
        for (uint i = 0; i < self.playerStates.length; i++) {
            self.playerStates[i] = deserializePlayerState(stream);
        }
    }

    function deserializePlayerState(SerialityBinaryStream.BinaryStream memory stream) private pure returns (ZBGameMode.PlayerState) {
        ZBGameMode.PlayerState memory player;

        player.id = stream.readString();
        player.deck = deserializeDeck(stream);
        player.cardsInHand = deserializeCardInstanceArray(stream);
        player.cardsInDeck = deserializeCardInstanceArray(stream);
        player.defense = stream.readUint8();
        player.currentGoo = stream.readUint8();
        player.gooVials = stream.readUint8();
        player.turnTime = stream.readUint32();
        player.initialCardsInHandCount = stream.readUint8();
        player.maxCardsInPlay = stream.readUint8();
        player.maxCardsInHand = stream.readUint8();
        player.maxGooVials = stream.readUint8();

        return player;
    }

    function serializeCardInstance(SerialityBinaryStream.BinaryStream memory stream, ZBGameMode.CardInstance card) private pure {
        stream.writeInt32(card.instanceId);
        stream.writeString(card.mouldName);
        stream.writeInt32(card.defense);
        stream.writeBool(card.attackInherited);
        stream.writeInt32(card.attack);
        stream.writeBool(card.defenseInherited);
        stream.writeInt32(card.gooCost);
        stream.writeBool(card.gooCostInherited);
    }

    function deserializeCardInstance(SerialityBinaryStream.BinaryStream memory stream) private pure returns (ZBGameMode.CardInstance) {
        ZBGameMode.CardInstance memory card;

        card.instanceId = stream.readInt32();
        card.mouldName = stream.readString();
        card.defense = stream.readInt32();
        card.defenseInherited = stream.readBool();
        card.attack = stream.readInt32();
        card.attackInherited = stream.readBool();
        card.gooCost = stream.readInt32();
        card.gooCostInherited = stream.readBool();

        return card;
    }

    function serializeCardInstanceArray(SerialityBinaryStream.BinaryStream memory stream, ZBGameMode.CardInstance[] cards) internal pure {
        stream.writeUint32(uint32(cards.length));

        for (uint i = 0; i < cards.length; i++) {
            serializeCardInstance(stream, cards[i]);
        }
    }

    function deserializeCardInstanceArray(SerialityBinaryStream.BinaryStream memory stream) private pure returns (ZBGameMode.CardInstance[]) {
        uint count = stream.readUint32();

        ZBGameMode.CardInstance[] memory cards = new ZBGameMode.CardInstance[](count);
        for (uint i = 0; i < count; i++) {
            cards[i] = deserializeCardInstance(stream);
        }

        return cards;
    }

    function deserializeDeck(SerialityBinaryStream.BinaryStream memory stream) private pure returns (ZBGameMode.Deck) {
        ZBGameMode.Deck memory deck;
        deck.id = stream.readInt64();
        deck.name = stream.readString();
        deck.heroId = stream.readInt64();

        return deck;
    }

    function serializeStartGameStateChangeAction(
        SerialityBinaryStream.BinaryStream memory stream,
        ZBEnum.GameStateChangeAction action
        ) private pure {
        stream.writeUint32(uint32(action));
    }

    function serializeStartGameStateChangeAction(
        SerialityBinaryStream.BinaryStream memory stream,
        ZBEnum.GameStateChangeAction action,
        ZBGameMode.Player player
        ) private pure {
        stream.writeUint32(uint32(action));
        stream.writeUint8(uint8(player));
    }

    // CardInstance

    function changeMouldName(ZBGameMode.CardInstance memory self, string mouldName) internal pure {
        self.mouldName = mouldName;
    }

    function changeDefense(ZBGameMode.CardInstance memory self, uint8 defense) internal pure {
        self.defense = defense;
        self.defenseInherited = false;
    }

    function changeAttack(ZBGameMode.CardInstance memory self, uint8 attack) internal pure {
        self.attack = attack;
        self.attackInherited = false;
    }

    function changeGooCost(ZBGameMode.CardInstance memory self, uint8 gooCost) internal pure {
        self.gooCost = gooCost;
        self.gooCostInherited = false;
    }

    // SerializedGameStateChanges

    function init(SerializedGameStateChanges memory self) internal pure {
        init(self, defaultSerializedGameStateChangesBufferSize);
    }

    function init(SerializedGameStateChanges memory self, uint bufferSize) internal pure {
        self.stream = SerialityBinaryStream.BinaryStream(new bytes(bufferSize), bufferSize);
    }

    function getBytes(SerializedGameStateChanges memory self) internal pure returns (bytes) {
        return self.stream.buffer;
    }

    function emitStateChange(SerializedGameStateChanges memory self) internal {
        emit GameStateChanges(getBytes(self));
    }

    function changePlayerDefense(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 defense) internal pure returns (uint) {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerDefense, player);
        stream.writeUint8(uint8(defense));
    }

    function changePlayerCurrentGoo(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 currentGoo) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerCurrentGoo, player);
        stream.writeUint8(uint8(currentGoo));
    }

    function changePlayerCurrentGooVials(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 gooVials) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerGooVials, player);
        stream.writeUint8(uint8(gooVials));
    }

    function changePlayerCardsInDeck(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards,
        uint cardCount
        ) internal pure {
        require(
            cardCount <= cards.length,
            "cardCount > cards.length"
        );

        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerCardsInDeck, player);
        stream.writeUint32(uint32(cardCount));

        for (uint i = 0; i < cardCount; i++) {
            serializeCardInstance(stream, cards[i]);
        }
    }

    function changePlayerCardsInDeck(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards
        ) internal pure {
        changePlayerCardsInDeck(self, player, cards, cards.length);
    }

    function changePlayerCardsInHand(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards,
        uint cardCount
        ) internal pure {
        require(
            cardCount <= cards.length,
            "cardCount > cards.length"
        );

        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerCardsInHand, player);
        stream.writeUint32(uint32(cardCount));

        for (uint i = 0; i < cardCount; i++) {
            serializeCardInstance(stream, cards[i]);
        }
    }

    function changePlayerCardsInHand(
        SerializedGameStateChanges memory self,
        ZBGameMode.Player player,
        ZBGameMode.CardInstance[] cards
        ) internal pure {
        changePlayerCardsInHand(self, player, cards, cards.length);
    }

    function changePlayerInitialCardsInHandCount(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerInitialCardsInHandCount, player);
        stream.writeUint8(count);
    }

    function changePlayerMaxCardsInPlay(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerMaxCardsInPlay, player);
        stream.writeUint8(count);
    }

    function changePlayerMaxCardsInHand(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerMaxCardsInHand, player);
        stream.writeUint8(count);
    }

    function changePlayerMaxGooVials(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint8 count) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerMaxGooVials, player);
        stream.writeUint8(count);
    }

    function changePlayerTurnTime(SerializedGameStateChanges memory self, ZBGameMode.Player player, uint32 turnTime) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartGameStateChangeAction(stream, ZBEnum.GameStateChangeAction.SetPlayerTurnTime, player);
        stream.writeUint32(turnTime);
    }

    // SerializedCustomUi

    function init(SerializedCustomUi memory self) internal pure {
        init(self, defaultSerializedCustomUiBufferSize);
    }

    function init(SerializedCustomUi memory self, uint bufferSize) internal pure {
        self.stream = SerialityBinaryStream.BinaryStream(new bytes(bufferSize), bufferSize);
    }

    function getBytes(SerializedCustomUi memory self) internal pure returns (bytes) {
        return self.stream.buffer;
    }

    function add(SerializedCustomUi memory self, ZBGameMode.CustomUiLabel label) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartCustomUiElement(stream, ZBEnum.CustomUiElement.Label, label.rect);
        stream.writeString(label.text);
    }

    function add(SerializedCustomUi memory self, ZBGameMode.CustomUiButton button) internal pure {
        SerialityBinaryStream.BinaryStream memory stream = self.stream;

        serializeStartCustomUiElement(stream, ZBEnum.CustomUiElement.Button, button.rect);
        stream.writeString(button.title);
        stream.writeBytes(button.onClickCallData);
    }

    function serializeStartCustomUiElement(SerialityBinaryStream.BinaryStream memory stream, ZBEnum.CustomUiElement element) private pure {
        stream.writeInt32(int32(element));
    }

    function serializeStartCustomUiElement(
        SerialityBinaryStream.BinaryStream memory stream,
        ZBEnum.CustomUiElement element,
        ZBGameMode.Rect rect
        ) private pure {
        serializeStartCustomUiElement(stream, element);
        serializeRect(stream, rect);
    }

    function serializeRect(SerialityBinaryStream.BinaryStream memory stream, ZBGameMode.Rect rect) private pure {
        serializeVector2Int(stream, rect.position);
        serializeVector2Int(stream, rect.size);
    }

    function serializeVector2Int(SerialityBinaryStream.BinaryStream memory stream, ZBGameMode.Vector2Int v) private pure {
        stream.writeInt32(v.x);
        stream.writeInt32(v.y);
    }
}
