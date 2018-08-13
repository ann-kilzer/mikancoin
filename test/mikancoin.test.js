var Mikancoin = artifacts.require("Mikancoin.sol");

const should = require('chai')
  .should();

contract('Mikancoin', function(accounts) {

    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

    beforeEach(async function () {
	this.mikancoin = await Mikancoin.new(300, accounts[0]);
    });
    
    describe("transfer", function() {
	describe("when the recipient is the zero address", function() {
	    const amount = 123;
	    it("reverts", async function () {		
		try {
		    await this.mikancoin.transfer(ZERO_ADDRESS, amount, { from: accounts[0] });
		} catch (error) {
		    error.message.should.include('revert', `Expected "revert", got ${error} instead`);
		    return;
		}
		should.fail('Revert did not happen');
	    });
	});
    });
});
