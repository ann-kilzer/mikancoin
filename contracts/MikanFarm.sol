pragma solidity 0.4.24;

import './Mikancoin.sol';

contract MikanFarm {

  Mikancoin [] public deployed;
  
  function deployMikancoin(uint _initialSupply) public returns (Mikancoin){
    Mikancoin latest = new Mikancoin(_initialSupply, msg.sender);
    deployed.push(latest);
    return latest;
  }

}
