
var OrisNFTOwnerShip = artifacts.require("../contracts/OrisNFTOwnerShip.sol");

const nftNames = ["NFT 1", "NFT 2", "NFT 3"];
contract("OrisNFTOwnerShip", (accounts) => {
    let [alice, bob, oris] = accounts;
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

        it("claim token id 1", async () => {
            console.log("create new nft")
            await contractInstance.createOrisNft(nftNames[0], { from: alice });

            console.log('claim nft');
            const result = await contractInstance.claimOrisNft(0, { from: bob });
            assert.equal(result.receipt.status, true);
        });

    });
});