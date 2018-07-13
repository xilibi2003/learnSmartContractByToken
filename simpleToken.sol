pragma solidity ^0.4.20;

contract SimpleToken {
    
    mapping(address => uint256) public balanceOf;
    event Transfer(address indexed receiver, uint256 value );
    
    constructor (uint256 initialSupply) {
        balanceOf[msg.sender] = initialSupply;
    }
    
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer( _to, _value);
    }
}