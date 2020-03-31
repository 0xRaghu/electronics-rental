const project = artifacts.require("AppUser");

module.exports = function(deployer) {
  deployer.deploy(project);
};