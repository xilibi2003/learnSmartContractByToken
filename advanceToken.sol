pragma solidity >=0.4.22 <0.7.0;

import './owned.sol';
import './erc20.sol';

contract AdvanceToken is ERC20, owned {

    mapping (address => bool) public frozenAccount;

    event AddSupply(uint amount);
    event FrozenFunds(address target, bool frozen);
    event Burn(address target, uint amount);

    constructor (string memory _name) ERC20(_name) public {

    }

    function mine(address target, uint amount) public onlyOwner {
        totalSupply += amount;
        _balances[target] += amount;

        emit AddSupply(amount);
        emit Transfer(address(0), target, amount);
    }

    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }


  function transfer(address _to, uint256 _value) public returns (bool success) {
        success = _transfer(msg.sender, _to, _value);
  }


  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(allowed[_from][msg.sender] >= _value);
        success =  _transfer(_from, _to, _value);
        allowed[_from][msg.sender] -= _value;
  }

  function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
      require(_to != address(0));
      require(!frozenAccount[_from]);

      require(_balances[_from] >= _value);
      require(_balances[ _to] + _value >= _balances[ _to]);

      _balances[_from] -= _value;
      _balances[_to] += _value;

      emit Transfer(_from, _to, _value);
      return true;
  }

    function burn(uint256 _value) public returns (bool success) {
        require(_balances[msg.sender] >= _value);

        totalSupply -= _value;
        _balances[msg.sender] -= _value;

        emit Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value)  public returns (bool success) {
        require(_balances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value);

        totalSupply -= _value;
        _balances[msg.sender] -= _value;
        allowed[_from][msg.sender] -= _value;

        emit Burn(msg.sender, _value);
        return true;
    }
}
