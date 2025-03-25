const SubdomainManager = artifacts.require("SubdomainManager");

module.exports = function (deployer) {
  deployer.deploy(SubdomainManager);
};
