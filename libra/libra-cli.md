# Lesson 12 Libra Basics

This lesson is about learning the `Libra CLI` to work with the libra network.  These are transcribed notes of Loom Network that wrote for the commands.

*Libra* is a blockchain money based network where transactions are going to happen like they work with *VISA, MasterCard, etc.* and to work with these one needs an account.

## Chapter 1 - Becoming an account owner

We can create account by

```bash
libra% account create
```

and this results in creating an account on the libra network

```plaintext
Creating/retrieving next account from wallet
Created/retrieved account #0 address dbbd9db9f
```

We will address this account as Alice's account. So let us look more into the details of this process. Alice's account was created from the wallet and was given an index in the blockchain, `0` and an address, `3ed8e5fafae4147b2a105a0be2f81972883441cfaaadf93fc0868e7a0253c4a8`.

## Chapter 2 - Checking account

Now since there are multiple people in the real world, we'll say Alice knows Bob and Eve. Since Bob and Eve are new to this they need accounts too so you can create the accounts using the the command mentioned above. Repeat twice for getting the account for Bob and Eve. We'll refer to index `1` as `Bob's address` and `2` as `Eve's address`, if created/referred to.

Now we have some accounts on the blockchain but let us say we need to know their details.

```sh
account list
```

which lists the accounts on the network.

```plaintext
User account index: 0, address: 3ed8e5fafae4147b2a105a0be2f81972883441cfaaadf93fc0868e7a0253c4a8, sequence number: 0
User account index: 1, address: 8337aac709a41fe6be03cad8878a0d4209740b1608f8a81566c9a7d4b95a2ec7, sequence number: 0
```

Here is something new, the sequence number. We will talk about this in chapter 4.

## Chapter 3 - Free Money for everybody

Since most of the work on the blockchain is done on the mainnet, we have to get the `LBR` the Libra Currency. But in development environment we work with testnets so we can mint the currency for test/development purposes.

Minting `LBR` is as easy as running

```sh
account mint account_index amt
```

This would credit the `account_index` with `amt` LBR.

```plaintext
Minted account_index with amt LBR
```

## Chapter 4 - Paying for an item

In a real world scenario, you would think that Alice being a good friends would have bought a something on behalf of Bob. Now Bob needs to transfer her an amount. Same behaviour can be done on the blockchain by running

```sh
tranfer sender reciever amt
```

Since this is hard to work around with mulitple payments going through with no balance, known as the `Finality` problem. It has been discussed in a post outside of this document.

Now it is hard to handle the problem of finality and thus, libra network has `sequence_numbers`, it increases for the sender once they send the `LBR`.

## Chapter 5 - Checking the transaction went through

One can query the sequence changes for the sender by running

```sh
query sequence sender
```

This helps in making sure of the finality problem.

## Chapter 6 - Checking the balance of the reciever

```sh
query balance account_index
```

Another way of checking the query with a huge receipt as a return is

```sh
query txn_acc_seq sender reciever true
```

the receipt on the network would look something like this

```plaintext
Getting committed transaction by account and sequence number
Committed transaction: SignedTransaction {
 raw_txn: RawTransaction {
        sender: 40d92e9800b0a915b8a445033e3c97dfb8fe2ba3e4a3aec96261dccb7955052c,
        sequence_number: 0,
        payload: {,
                transaction: peer_to_peer_transaction,
                args: [
                        {ADDRESS: 7fc0d913e81a222927406f634b0157dd6a9ad639faad2b280d3555011d761b4f},
                        {U64: 100000000},
                ]
        },
        max_gas_amount: 140000,
        gas_unit_price: 0,
        expiration_time: 1569836020s,
},
 public_key: Ed25519PublicKey(
    PublicKey(CompressedEdwardsY: [73, 175, 171, 78, 17, 239, 54, 117, 117, 145, 33, 237, 107, 58, 189, 31, 58, 137, 81, 105, 252, 26, 133,
89, 119, 193, 111, 233, 100, 82, 90, 45]), EdwardsPoint{
        X: FieldElement51([309902793287818, 1485124018439498, 634313704607495, 1730304085918062, 1719929927279149]),
        Y: FieldElement51([1951707473620809, 1545519053581990, 1484499216954601, 206350672821812, 797855242426108]),
        Z: FieldElement51([1, 0, 0, 0, 0]),
        T: FieldElement51([87169944716583, 1916378871435050, 1034728963396755, 2048077977546062, 329376871138617])
    }),
),
 signature: Ed25519Signature(
    Signature( R: CompressedEdwardsY: [187, 5, 197, 84, 64, 173, 46, 68, 115, 187, 224, 118, 176, 190, 138, 127, 140, 254, 201, 126, 187, 231, 121, 246, 30, 178, 86, 79, 28, 64, 98, 183], s: Scalar{
        bytes: [144, 82, 207, 139, 15, 235, 72, 118, 85, 160, 13, 207, 44, 248, 244, 31, 32, 168, 13, 88, 15, 89, 169, 240, 52, 233, 231, 172, 45, 46, 170, 9],
    } ),
),
 }
...
```

*Did you know?*

- When you query a transaction, the unit shown is actually microlibra which is defined as 1/1000000 of a whole Libra. The smallest unit for regular currencies is usually called a Pip which is 1/10000 or 100 times larger than a microlibra.

## Chapter 7 - Connecting to the Testnet Yourself (part 1)

Connecting to the testnet can get complicated. Now let us actually connect to the testnet.

Installing the libra network

- We need to get the code for the libra network and connect to the testnet branch
- Run the provided `dev_setup` script

It can be run as follows:

```sh
# Cloning libra into the current working directory
git clone https://github.com/libra/libra.git

# Moving into libra directory
cd libra

# Changing branches from master to testnet
git checkout testnet

# Running the dev_setup.sh script
./scripts/dev_setup.sh

```

This will setup the development testnet version on the machine

## Chapter 8 - Connecting to the Testnet yourself (part 2)

Once you have the testnet, you just need to run it to work with it which can be done as follows

```sh
./scripts/cli/start_cli_testnet.sh
```

This initiated the testnet cli. It might build some more dependencies, if it is a first time run.

```sh
Building and running client in debug mode.
    Updating git repository `https://github.com/calibra/curve25519-dalek.git`
    Updating git repository `https://github.com/calibra/ed25519-dalek.git`
    Updating git repository `https://github.com/calibra/x25519-dalek.git`
    Updating git repository `https://github.com/calibra/rust-curve25519-fiat.git`
  Downloaded reqwest v0.9.19
  Downloaded serde v1.0.99
  Downloaded typed-arena v1.5.0
  ....
```

The final output results like the following.

```sh
Connected to validator at: ac.testnet.libra.org:8000
usage: <command> <args>

Use the following commands:

account | a
        Account operations
query | q
        Query operations
transfer | transferb | t | tb
        <sender_account_address>|<sender_account_ref_id> <receiver_account_address>|<receiver_account_ref_id> <number_of_coins> [gas_unit_price_in_micro_libras (default=0)] [max_gas_amount_in_micro_libras (default 140000)] Suffix 'b' is for blocking.
        Transfer coins (in libra) from account to another.
help | h
        Prints this help
quit | q!
        Exit this client


Please, input commands:
```

Thank you for successfully following the steps to work with the Libra CLI.
