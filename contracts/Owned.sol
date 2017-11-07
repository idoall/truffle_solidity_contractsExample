pragma solidity ^0.4.17;
import './interfaces/IOwned.sol';

/*
    owned 是一个管理者
*/
contract Owned is IOwned {
    address public owner;
    address public newOwner;

    event OwnerUpdate(address _prevOwner, address _newOwner);

    /**
     * 初始化构造函数
     */
    function Owned() public {
        owner = msg.sender;
    }

    /**
     * 判断当前合约调用者是否是管理员
     */
    modifier onlyOwner {
        assert(msg.sender == owner);
        _;
    }

    /**
     * 指派一个新的管理员
     * @param  _newOwner address 新的管理员帐户地址
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != owner);
        newOwner = _newOwner;
    }

    /**
        @dev 新的管理员，确认接受做为管理员
    */
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = 0x0;
    }
}
