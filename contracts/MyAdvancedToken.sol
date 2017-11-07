pragma solidity ^0.4.17;
import './Token.sol';
import './Owned.sol';
import './interfaces/IMyAdvancedToken.sol';

/**
 * @title 高级版代币
 * 增加冻结用户、挖矿、根据指定汇率购买(售出)代币价格的功能
 */
contract MyAdvancedToken is IMyAdvancedToken, Owned, Token {

    //卖出的汇率,一个代币，可以卖出多少个以太币，单位是wei
    uint256 public sellPrice;

    //买入的汇率,1个以太币，可以买几个代币
    uint256 public buyPrice;

    //是否冻结帐户的列表
    mapping (address => bool) public frozenAccount;

    //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端
    event FrozenFunds(address target, bool frozen);


    /*初始化合约，并且把初始的所有的令牌都给这合约的创建者
     */
    function MyAdvancedToken()
      public
      Token ('mshk.top Advanced Token', 'MSHK-H', 2)
    {
        sellPrice = 2;     //设置1个单位的代币(单位是wei)，能够卖出2个以太币
        buyPrice = 4;      //设置1个以太币，可以买0.25个代币
    }


    /**
     * 私有方法，从指定帐户转出余额
     * @param  _from address 发送代币的地址
     * @param  _to address 接受代币的地址
     * @param  _value uint256 接受代币的数量
     */
    function _transfer(address _from, address _to, uint _value)
        validAddress(_from)
        validAddress(_to)
        internal
    {
        //检查发送者是否拥有足够余额
        require (balanceOf[_from] > _value);

        //检查是否溢出
        require (balanceOf[_to] + _value > balanceOf[_to]);

        //检查 冻结帐户
        require(!frozenAccount[_from]);
        require(!frozenAccount[_to]);



        //从发送者减掉发送额
        balanceOf[_from] = safeSub(balanceOf[_from], _value);

        //给接收者加上相同的量
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);

        //通知任何监听该交易的客户端
        Transfer(_from, _to, _value);

    }

    /**
     * 合约拥有者，可以为指定帐户创造一些代币
     * @param  target address 帐户地址
     * @param  mintedAmount uint256 增加的金额(单位是wei)
     */
    function mintToken(address target, uint256 mintedAmount)
        validAddress(target)
        public
        onlyOwner
    {

        //给指定地址增加代币，同时总量也相加
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;


        Transfer(0, this, mintedAmount);
        Transfer(this, target, mintedAmount);
    }

    /**
     * 增加冻结帐户名称
     *
     * 你可能需要监管功能以便你能控制谁可以/谁不可以使用你创建的代币合约
     *
     * @param  target address 帐户地址
     * @param  freeze bool    是否冻结
     */
    function freezeAccount(address target, bool freeze)
        validAddress(target)
        public
        onlyOwner
    {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }

    /**
     * 设置买卖价格
     *
     * 如果你想让ether(或其他代币)为你的代币进行背书,以便可以市场价自动化买卖代币,我们可以这么做。如果要使用浮动的价格，也可以在这里设置
     *
     * @param newSellPrice 新的卖出价格
     * @param newBuyPrice 新的买入价格
     */
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    /**
     * 使用以太币购买代币
     */
    function buy() payable public {
      uint amount = msg.value / buyPrice;

      _transfer(this, msg.sender, amount);
    }

    /**
     * @dev 卖出代币
     * @return 要卖出的数量(单位是wei)
     */
    function sell(uint256 amount) public {

        //检查合约的余额是否充足
        require(this.balance >= amount * sellPrice);

        _transfer(msg.sender, this, amount);

        msg.sender.transfer(amount * sellPrice);
    }
}
