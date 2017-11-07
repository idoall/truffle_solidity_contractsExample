/* global artifacts */
/* eslint-disable prefer-reflect */

const Utils = artifacts.require('./Utils.sol');
const Owned = artifacts.require('./Owned.sol');
const Token = artifacts.require('./Token.sol');
const MyAdvancedToken = artifacts.require('./MyAdvancedToken.sol');
const SmartToken = artifacts.require('./SmartToken.sol');
const Crowdsale = artifacts.require('./Crowdsale.sol');

module.exports = async (deployer) => {
    deployer.deploy(Utils);
    deployer.deploy(Owned);
    deployer.deploy(Token, 'mshk.top Token', 'MSHK-S', 0);
    deployer.deploy(MyAdvancedToken);
    await deployer.deploy(SmartToken, 'mshk.top SmartToken', 'MSHK-Smart', 2);
    deployer.deploy(Crowdsale, '0x777', 100, 30, SmartToken.address);
};
