pragma solidity ^0.4.24;

struct GameState {
    int64 id;
    uint8 currentPlayerIndex;
    PlayerState[] playerStates;
}

struct PlayerState {
    string id;
    CardInstance[] cardsInHand;
    CardInstance[] cardsInDeck;
    Deck deck;
    uint8 defense;
    uint8 currentGoo;
    uint8 gooVials;
    uint8 initialCardsInHandCount;
    uint8 maxCardsInPlay;
    uint8 maxCardsInHand;
    uint8 maxGooVials;
}

struct CardInstance {
    int32 instanceId;
    string mouldName;
    int32 defense;
    bool defenseInherited;
    int32 attack;
    bool attackInherited;
    int32 gooCost;
    bool gooCostInherited;
}

struct Deck {
    int64 id;
    string name;
    int64 heroId;
}