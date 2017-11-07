var Migrations = artifacts.require("./helpers/Migrations.sol");
var Hello_mshk_top = artifacts.require("./helpers/Hello_mshk_top.sol");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Hello_mshk_top);
};
