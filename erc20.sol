pragma solidity ^0.4.20;

import './erc20interface.sol';

contract ERC20 is ERC20Interface {

    // 对自动生成对应的balanceOf方法
    mapping(address => uint256) public balanceOf;

    // allowed保存每个地址（第一个address） 授权给其他地址(第二个address)的额度（uint256）
    mapping(address => mapping(address => uint256)) allowed;

    constructor(string _name) public {
       name = _name;  // "UpChain";
       symbol = "UPT";
       decimals = 0;
       totalSupply = 1000000;
       balanceOf[msg.sender] = totalSupply;
    }

  // 转移
  function transfer(address _to, uint256 _value) returns (bool success) {
      require(_to != address(0));
      require(balanceOf[msg.sender] >= _value);
      require(balanceOf[ _to] + _value >= balanceOf[ _to]);   // 防止溢出


      balanceOf[msg.sender] -= _value;
      balanceOf[_to] += _value;

      // 发送事件
      emit Transfer(msg.sender, _to, _value);

      return true;
  }


  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      require(_to != address(0));
      require(allowed[_from][msg.sender] >= _value);
      require(balanceOf[_from] >= _value);
      require(balanceOf[ _to] + _value >= balanceOf[ _to]);

      balanceOf[_from] -= _value;
      balanceOf[_to] += _value;

      allowed[_from][msg.sender] -= _value;

      emit Transfer(msg.sender, _to, _value);
      return true;
  }

  function approve(address _spender, uint256 _value) returns (bool success) {
      allowed[msg.sender][_spender] = _value;

      emit Approval(msg.sender, _spender, _value);
      return true;
  }

  function allowance(address _owner, address _spender) view returns (uint256 remaining) {
      return allowed[_owner][_spender];
  }

}
