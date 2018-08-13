pragma solidity 0.4.24;

import 'truffle/Assert.sol';
import 'truffle/DeployedAddresses.sol';
import '../contracts/MikanFarm.sol';
import '../contracts/Mikancoin.sol';

contract TestMikancoin {

  function testConstructor() public {
    MikanFarm farm = MikanFarm(DeployedAddresses.MikanFarm());  // Get the address and cast it
    Mikancoin mikan = farm.deployMikancoin(100);

    Assert.equal(mikan.totalSupply(), 100, "Total supply should be 100 Mikan");
    Assert.equal(mikan.balanceOf(this), 100, "We should have 100 Mikan");
  }

  function testTransfer() public {
    uint startTokens = 100;
    MikanFarm farm = MikanFarm(DeployedAddresses.MikanFarm());  // Get the address and cast it
    Mikancoin mikan = farm.deployMikancoin(startTokens);

    Assert.equal(mikan.balanceOf(this), startTokens, "We should have 100 Mikan");
    address fox = 0x284A84baA00626e2773a1138D53923b4acAED2F4;
    Assert.equal(mikan.balanceOf(fox), 0, "Fox has 0 mikan");

    uint tokens = 7;
    Assert.isTrue(mikan.transfer(fox, tokens), "Transfer should succeed");
    Assert.equal(mikan.balanceOf(fox), tokens, "Fox balance after transfer");
    Assert.equal(mikan.balanceOf(this), startTokens - tokens, "Sender balance after transfer");
  }

  /** This creates a horrible stack trace. Better to test this case in javascript.
  function testBadTransfer() public {
    uint startTokens = 100;
    MikanFarm farm = MikanFarm(DeployedAddresses.MikanFarm());  // Get the address and cast it
    Mikancoin mikan = farm.deployMikancoin(startTokens);
    
    Assert.isFalse(mikan.transfer(0x0, 5), "Transfer to 0 address should fail"); // require() fails and therefore this will revert
  }
  */
}
