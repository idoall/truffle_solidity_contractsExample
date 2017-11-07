pragma solidity ^0.4.17;
import './Utils.sol';
import './interfaces/IToken.sol';

contract Token is IToken, Utils {
    /* 公共变量 */
    string public standard = 'https://mshk.top';
    string public name = ''; //代币名称
    string public symbol = ''; //代币符号比如'$'
    uint8 public decimals = 0;  //代币单位
    uint256 public totalSupply = 0; //代币总量

    /*记录所有余额的映射*/
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* 在区块链上创建一个事件，用以通知客户端*/
    event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value); //设置允许用户支付最大金额通知

    /* 初始化合约，并且把初始的所有代币都给这合约的创建者
     * @param tokenName 代币名称
     * @param tokenSymbol 代币符号
     * @param decimalsUnits 代币后面的单位，小数点后面多少个0，以太币一样后面是是18个0
     */
    function Token(string tokenName, string tokenSymbol, uint8 decimalsUnits) public {

        require(bytes(tokenName).length > 0 && bytes(tokenSymbol).length > 0); // validate input

        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalsUnits;

    }


    /**
     * 私有方法从一个帐户发送给另一个帐户代币
     * @param  _from address 发送代币的地址
     * @param  _to address 接受代币的地址
     * @param  _value uint256 接受代币的数量
     */
    function _transfer(address _from, address _to, uint256 _value)
      internal
      validAddress(_from)
      validAddress(_to)
    {


      //检查发送者是否拥有足够余额
      require(balanceOf[_from] >= _value);

      //检查是否溢出
      require(balanceOf[_to] + _value > balanceOf[_to]);

      //保存数据用于后面的判断
      uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);

      //从发送者减掉发送额
      balanceOf[_from] = safeSub(balanceOf[_from], _value);

      //给接收者加上相同的量
      balanceOf[_to] += safeAdd(balanceOf[_to], _value);

      //通知任何监听该交易的客户端
      Transfer(_from, _to, _value);

      //判断买、卖双方的数据是否和转换前一致
      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

    }

    /**
     * 从主帐户合约调用者发送给别人代币
     * @param  _to address 接受代币的地址
     * @param  _value uint256 接受代币的数量
     */
    function transfer(address _to, uint256 _value)
      public
      validAddress(_to)
      returns (bool)
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * 从某个指定的帐户中，向另一个帐户发送代币
     *
     * 调用过程，会检查设置的允许最大交易额
     *
     * @param  _from address 发送者地址
     * @param  _to address 接受者地址
     * @param  _value uint256 要转移的代币数量
     * @return        是否交易成功
     */
    function transferFrom(address _from, address _to, uint256 _value)
        public
        validAddress(_from)
        validAddress(_to)
        returns (bool)
    {
        //检查发送者是否拥有足够余额支出的设置
        require(_value <= allowance[_from][msg.sender]);   // Check allowance

        allowance[_from][msg.sender] -= safeSub(allowance[_from][msg.sender], _value);

        _transfer(_from, _to, _value);

        return true;
    }

    /**
     * 设置帐户允许支付的最大金额
     *
     * 一般在智能合约的时候，避免支付过多，造成风险
     *
     * @param _spender 帐户地址
     * @param _value 金额
     */
    function approve(address _spender, uint256 _value)
        public
        validAddress(_spender)
        returns (bool success)
    {

        require(_value == 0 || allowance[msg.sender][_spender] == 0);

        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
}
