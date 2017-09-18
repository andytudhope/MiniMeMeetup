var MiniMeTokenFactory = artifacts.require("./MiniMeTokenFactory.sol");

module.exports = function(deployer) {
  deployer.deploy(MiniMeTokenFactory);
};
