#!/bin/bash
# First, check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We will be playing the role of three parties.

The private key and address of the first bidder.
private_key: APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK
address: aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke

The private key and address of the second bidder.
private_key: APrivateKey1zkpAFshdsj2EqQzXh5zHceDapFWVCwR6wMCJFfkLYRKupug
address: aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4

The private key and address of the auctioneer.
private_key: APrivateKey1zkp5wvamYgK3WCAdpBQxZqQX8XnuN2u11Y6QprZTriVwZVc
address: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh
"

echo "
Let's start an auction!

###############################################################################
########                                                               ########
########           Step 0: Initialize a new 2-party auction            ########
########                                                               ########
###############################################################################
"

# Step 1: First bidder places a bid of 10
echo "
### Step 1: First bidder places a bid of 10 ###

"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run place_bid aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke 10u64

# Step 2: Second bidder places a bid of 90
echo "
### Step 2: Second bidder places a bid of 90 ###

"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkpAFshdsj2EqQzXh5zHceDapFWVCwR6wMCJFfkLYRKupug
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run place_bid aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4 90u64

# Step 3: Auctioneer resolves the winning bid
echo "
### Step 3: Auctioneer resolves the winning bid ###

"

echo "
NETWORK=testnet
PRIVATE_KEY=APrivateKey1zkp5wvamYgK3WCAdpBQxZqQX8XnuN2u11Y6QprZTriVwZVc
ENDPOINT=https://api.explorer.aleo.org/v1
" > .env

leo run resolve "{
        owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
        bidder: aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
    }" "{
        owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
        bidder: aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

# Step 4: Finish the auction
echo "
### Step 4: Auctioneer finishes the auction ###

"

leo run finish "{
        owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
        bidder: aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

# Step 5: Auctioneer runs claim function for the winning bidder
echo "
### Step 5: Winning bidder claims the reward ###

"

leo run claim "{
        owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
        bidder: aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4.private,
        amount: 90u64.private,
        is_winner: true.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

echo "
###############################################################################
########                                                               ########
########      The winning bidder claims their reward. Auction ends.    ########
########                                                               ########
###############################################################################
"

