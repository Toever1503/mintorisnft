
var OrisNFTOwnerShip = artifacts.require("../contracts/OrisNFTOwnerShip.sol");

const nftNames = ["NFT 1", "NFT 2", "NFT 3"];
contract("OrisNFTOwnerShip", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await OrisNFTOwnerShip.new();
    });
    // xit("create new nft", async () => {
    //     const result =  await contractInstance.createOrisNft(nftNames[0], { from: alice });
    //     console.log('result: ', result);
    //     assert.equal(result.receipt.status, true);
    // })
    context("claim nft", async () => {
        it("get detail token id 1", async () => {
            await contractInstance.createOrisNft(nftNames[0], { from: alice });
            const result = await contractInstance.detailNft(0, { from: alice });
            assert.equal(result.name, nftNames[0]);
        });

        it("claim token id 1", async () => {
            console.log("create new nft")
            await contractInstance.createOrisNft(nftNames[0], { from: alice });
            console.log("begin mint")
            await contractInstance.beginMint(0, { from: bob });
            console.log("has followed fb")
            await contractInstance.hasFollowedFb(0, { from: bob });
            console.log("share a post fb")
            await contractInstance.hasSharedFbPost(0, { from: bob });

            console.log('claim nft');
            const result = await contractInstance.claimOrisNft(0, { from: bob });
            assert.equal(result.receipt.status, true);
        });

    });
});