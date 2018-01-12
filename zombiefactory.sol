pragma solidity ^0.4.19;

contract ZombieFactory {

    // a normal program can listen to this blockchain event
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // mapping is like a dictionary, and address an eth address type
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // this is an internal function, like private but can also be called when inherited
    // note: external (not used here) can only be called outside the contract
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // msg.sender is the address of the caller
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        // call the event, so the listeners will get the notice of a new created zombie
        NewZombie(id, _name, _dna);
    }

    // view functions can access but not change storage variables
    // note: pure (not used here) is all self contained and only uses the parameters
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
