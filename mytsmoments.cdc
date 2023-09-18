import TopShot from "contracts/TopShot.cdc"

contract mytsmoments: NonFungibleToken {

    // -----------------------------------------------------------------------
    // mytsmoments deployment variables
    // -----------------------------------------------------------------------

    // The address of the USDC token
    pub fun USDCAddress() : Address { return 0x92b6548e4673381269c936783e9bf37326a0006d }

    // The percentage of the sale price that the creator of the moment will receive as royalties
    pub fun RoyaltyPercentage() : UInt8 { return 10 }

    // -----------------------------------------------------------------------
    // mytsmoments contract Events
    // -----------------------------------------------------------------------

    // Emitted when a new moment is created
    pub event MomentCreated(momentID: UInt64, playID: UInt32, metadata: {String: String})

    // -----------------------------------------------------------------------
    // mytsmoments contract-level fields.
    // These contain actual values that are stored in the smart contract.
    // -----------------------------------------------------------------------

    // The ID that is used to create Moments. 
    // Every time a Moment is created, momentID is assigned 
    // to the new Moment's ID and then is incremented by 1.
    pub var nextMomentID: UInt64

    // -----------------------------------------------------------------------
    // mytsmoments contract-level functions
    // -----------------------------------------------------------------------

    // Creates a new moment.
    //
    // Args:
    //   playID: The ID of the Play that the user wants to create a moment for.
    //   metadata: A map of strings to strings containing the metadata for the new moment.
    //   amount: The number of moments to create.
    //   burnMoments: An array of the moments that the user wants to burn in order to create the new moment.
    //   usdcAmount: The amount of USDC that the user have to pay in order to create the new moment.
    //
    // Returns:
    //   An array of the IDs of the new moments that were created.
    pub fun createMoments(playID: UInt32, metadata: {String: String}, amount: UInt32, burnMoments: [UInt64], usdcAmount: UInt64): [UInt64] {

        // Check if the user is trying to create more moments than they have.
        assert(amount <= burnMoments.length, message: "You cannot create more moments than you have.")

        // Check if the user has paid enough USDC.
        assert(usdcAmount >= amount * RoyaltyPercentage(), message: "You must pay enough USDC to create moments.")

        // Burn the specified moments from the user's collection.
        destroyMoments(self.accountID, burnMoments)

        // Mint the new moments.
        let newMomentIDs = mintMoments(playID, metadata, amount)

        // Transfer the royalties to the creator of the moment.
        transfer(USDCAddress(), self.accountID, usdcAmount)

        return newMomentIDs
    }

    // Mints a new moment.
    //
    // Args:
    //   playID: The ID of the Play that the user wants to create a moment for.
    //   metadata: A map of strings to strings containing the metadata for the new moment.
    //   amount: The number of moments to mint.
    //
    // Returns:
    //   An array of the IDs of the new moments that were minted.
    private fun mintMoments(playID: UInt32, metadata: {String: String}, amount: UInt32): [UInt64] {

    // Initialize the newMomentIDs array.
    var newMomentIDs: [UInt64] = []

    // Mint the specified number of moments.
    for i in 0 .amount - 1 {

        // Increment the next moment ID.
        nextMomentID += 1; //unexpected token in expression: '='

        // Create a new moment.
        let momentID = nextMomentID

        // Mint the moment.
        mintMoment(momentID, playID, metadata)

        // Add the moment ID to the array of new moment IDs.
        newMomentIDs.append(momentID)
    }

    // Mints a new moment.
    //
    // Args:
    //   playID: The ID of the Play that the user wants to create a moment for.
    //   metadata: A map of strings to strings containing the metadata for the new moment.
    //   amount: The number of moments to mint.
    //
    // Returns:
    //   An array of the IDs of the new moments that were minted.
   private fun mintMoments(playID: UInt32, metadata: {String: String}, amount: UInt32): [UInt64] {

        // Initialize the newMomentIDs array.
        var newMomentIDs: [UInt64] = []

        // Mint the specified number of moments.
        for i in 0 .amount - 1 {

            // Increment the next moment ID.
            nextMomentID += 1; //According with flow I can´t deploy because this error

            // Create a new moment.
            let momentID = nextMomentID

            // Mint the moment.
            mintMoment(momentID, playID, metadata)

            // Add the moment ID to the array of new moment IDs.
            newMomentIDs.append(momentID)
        }

        // Transfer the royalties to the creator of the moment.
        // This is done by calling a separate function called `transferRoyalties()`. 
        transferRoyalties(USDCAddress(), self.accountID, usdcAmount)

        return newMomentIDs

        ini(){
            newMomentIDs: [UInt64] = []
        }
    }
 

    // Transfers a moment to a new owner.
    //
    // Args:
    //   newOwnerID: The ID of the new owner of the moment
    // Check if the new moment must be from the same player as the moments being burned.
// If you use multiple players moments to burn in order to create a new personal collection
// the amount of the collection will be the half of the amount of moments burned.
private fun checkMomentPlayers(burnedMoments: [UInt64], newMomentPlayer: String?) {

    // Check if the new moment player is empty.
    assert(newMomentPlayer != nil, message: "The new moment player cannot be empty.")

    // Get the player ID of the first burned moment.
    let firstBurnedMomentPlayerID = getPlayerIDFromMomentID(burnedMoments[0])

    // Check if all of the burned moments are from the same player as the new moment.
    for burnedMoment in burnedMoments {

        let burnedMomentPlayerID = getPlayerIDFromMomentID(burnedMoment)

        assert(burnedMomentPlayerID == firstBurnedMomentPlayerID, message: "All of the burned moments must be from the same player as the new moment.")
    }

    // If there are multiple players moments to burn in order to create a new personal collection
    // the amount of the collection will be the half of the amount of moments burned.
    if (burnedMoments.length > 1) {

        // Reduce the amount of new moments by half.
        amount /= 2
    }
}
