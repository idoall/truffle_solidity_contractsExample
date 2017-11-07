pragma solidity ^0.4.17;

/*
    Standard ISmartyToken interface
*/
contract ISmartToken {

    function issue(address _to, uint256 _value) public;
}
