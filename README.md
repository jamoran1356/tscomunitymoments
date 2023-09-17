# CREATING NBATOPSHOT MOMENTS
This contract, `mytsmoments`, is a smart contract written in Cadence. The contract extends the `NonFungibleToken` contract and provides functionality for creating and managing moments.

## Deployment Variables

- `USDCAddress()`: Returns the address of the USDC token.
- `RoyaltyPercentage()`: Returns the percentage of the sale price that the creator of the moment will receive as royalties.

## Events

- `MomentCreated(momentID: UInt64, playID: UInt32, metadata: {String: String})`: Emitted when a new moment is created.

## Contract-level Fields

- `nextMomentID: UInt64`: The ID used to create moments. It is incremented by 1 each time a new moment is created.

## Contract-level Functions

### `createMoments(playID: UInt32, metadata: {String: String}, amount: UInt32, burnMoments: [UInt64], usdcAmount: UInt64)`

This function is used to create new moments.

Parameters:
- `playID: UInt32`: The ID of the play for which the moments will be created.
- `metadata: {String: String}`: A map of strings to strings containing the metadata for the new moments.
- `amount: UInt32`: The number of moments to create.
- `burnMoments: [UInt64]`: An array of the moments that will be burned to create the new moments.
- `usdcAmount: UInt64`: The amount of USDC that needs to be paid to create the new moments.

Returns:
- An array of the IDs of the new moments that were created.

This function performs the following steps:
1. Checks if the user is trying to create more moments than they have.
2. Checks if the user has paid enough USDC.
3. Burns the specified moments from the user's collection.
4. Mints the new moments.
5. Transfers the royalties to the creator of the moment.
6. Returns the IDs of the new moments.

### `mintMoments(playID: UInt32, metadata: {String: String}, amount: UInt32)`

This private function is used to mint new moments.

Parameters:
- `playID: UInt32`: The ID of the play for which the moments will be created.
- `metadata: {String: String}`: A map of strings to strings containing the metadata for the new moments.
- `amount: UInt32`: The number of moments to mint.

Returns:
- An array of the IDs of the new moments that were minted.

This function performs the following steps:
1. Initializes an empty array `newMomentIDs` to store the IDs of the new moments.
2. Loops `amount` times to mint the specified number of moments.
3. Increments the `nextMomentID` by 1 to get the ID for the new moment.
4. Creates a new moment with the generated ID, playID, and metadata.
5. Adds the moment ID to the `newMomentIDs` array.
6. Returns the array of new moment IDs.

### `checkMomentPlayers(burnedMoments: [UInt64], newMomentPlayer: String?)`

This private function checks if the new moment to be created must be from the same player as the moments being burned. If multiple players' moments are burned to create a new personal collection, the amount of the collection will be half of the amount of moments burned.

Parameters:
- `burnedMoments: [UInt64]`: An array of the moments that will be burned.
- `newMomentPlayer: String?`: The player ID of the new moment.

This function performs the following steps:
1. Checks if the new moment player is empty.
2. Gets the player ID of the first burned moment.
3. Checks if all of the burned moments are from the same player as the new moment.
4. If there are multiple players' moments to burn, reduces the amount of new moments by half.

Please note that the code provided is a partial implementation, and the contract may have other functions and features not shown in the provided code snippet. 

## This is my entry for the Cadence Competition holded by Emerald Dao Team