pragma solidity ^0.4.17;
import './Token.sol';
import './Owned.sol';
import './interfaces/ISmartToken.sol';

contract SmartToken is ISmartToken, Owned, Token {

    string public version = '0.1';

    // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
    event NewSmartToken(address _token);

    /* 初始化合约，并且把初始的所有代币都给这合约的创建者
     * @param tokenName 代币名称
     * @param tokenSymbol 代币符号
     * @param decimalsUnits 代币后面的单位，小数点后面多少个0，以太币一样后面是是18个0
     */
    function SmartToken(string tokenName, string tokenSymbol, uint8 decimalsUnits)
        public
        Token (tokenName, tokenSymbol, decimalsUnits)
    {
        NewSmartToken(address(this));
    }


    /**
     * 增加代币，并将代币发送给捐赠新用户
     * @param  _to address 接受代币的地址
     * @param  _amount uint256 接受代币的数量
     */
    function issue(address _to, uint256 _amount)
       validAddress(_to)
       public
   {
        _amount = _amount * 10 ** uint256(decimals);
        totalSupply = totalSupply + _amount;
        balanceOf[_to] = safeAdd(balanceOf[_to], _amount);

        //通知任何监听该交易的客户端
        Transfer(this, _to, _amount);
    }


}
