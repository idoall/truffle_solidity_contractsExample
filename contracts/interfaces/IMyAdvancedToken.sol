pragma solidity ^0.4.17;

/*
    Standard IMyAdvancedToken interface
*/
contract IMyAdvancedToken {

    function _transfer(address _from, address _to, uint256 _value) internal;
    function mintToken(address target, uint256 mintedAmount) public;
    function freezeAccount(address target, bool freeze) public;
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public;
    function buy() payable public;
    function sell(uint256 amount) public;
}
