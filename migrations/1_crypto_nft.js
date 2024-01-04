var OrisNFTOwnerShip = artifacts.require("../contracts/OrisNFTOwnerShip.sol");
module.exports = function(deployer) {
  deployer.deploy(OrisNFTOwnerShip);
};