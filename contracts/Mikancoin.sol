/**
 * Created on: August 2018
 * @summary: A simple token for demoing solidity and javascript tests
 * @author: Ann Kilzer
 * akilzer@gmail.com
 */
pragma solidity 0.4.24;

/**
 * Inspired by the ethereum.org token, modified and simplified
 *
 * @title Mikancoin
 */
contract Mikancoin {

  uint public totalSupply;
  
  // balanceOf keeps track of each address's value
  mapping (address => uint) public balanceOf;
  // allowance grants other owners control over a portion of the tokens
  // This is a map of owners to spenders to allowance
  mapping (address => mapping (address => uint)) public allowance;

/**
 * @dev Constructs a new Mikancoin contract
 * @param _initialSupply : How many tokens are granted
 * @param _initialOwner : The account to grant the initial supply of coins
 */
  constructor(uint _initialSupply, address _initialOwner) public {
    require(_initialOwner != 0x0);
    totalSupply = _initialSupply;
    balanceOf[_initialOwner] = _initialSupply;
    emit Transfer(0x0, _initialOwner, totalSupply);
  }

/**
 * @dev Retrieves the balance of a given address
 * @param _tokenOwner :  The address to look up
 * @return : Number of tokens owned by the account
 */
  function balanceOf(address _tokenOwner) public view returns (uint balance) {
    return balanceOf[_tokenOwner];
  }

/**
 * @dev Returns a spender's allowance from a token owner
 * @param _tokenOwner : The owner of the tokens
 * @param _spender : The party spending the tokens
 * @return : The number of tokens that the spender can spend on the tokenOwner's behalf
 */
  function allowance(address _tokenOwner, address _spender) public view returns (uint remaining) {
    return allowance[_tokenOwner][_spender];
  }

  /**
   * @dev Internal helper for transfer, can only be called by this contract.
   * @param _from : The address of the sender
   * @param _to : The address of the recipient
   * @param _tokens : The number of tokens to send
   */
  function _transfer(address _from, address _to, uint _tokens)
  validDestination(_to)
  internal {
    require(balanceOf[_from] >= _tokens);
    require(balanceOf[_to] + _tokens >= balanceOf[_to]); // overflow check
    uint previousBalances = balanceOf[_from] + balanceOf[_to];
    balanceOf[_from] -= _tokens;
    balanceOf[_to] += _tokens;
    emit Transfer(_from, _to, _tokens);
    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
  }

/**
 * @dev Sends tokens from the caller to a recipient
 * @param _to :  The address of the recipient
 * @param _tokens :  The number of tokens to send
 * @return : true if successful
 */
  function transfer(address _to, uint _tokens) public returns (bool success) {
    _transfer(msg.sender, _to, _tokens);
    return true;
  }

  /**
   * @dev Grants the spender an allowance of _tokens to spend on the sender's behalf
   * Note that this doesn't sum the tokens, it overwrites any previous allowance.
   * @param _spender : The address to grant the allowance to
   * @param _tokens : The number of tokens to set the allowance to
   */
  function approve(address _spender, uint _tokens) public returns (bool success) {
    require(msg.sender != _spender); // Don't be a dummy
    allowance[msg.sender][_spender] = _tokens;
    emit Approval(msg.sender, _spender, _tokens);
    return true;
  }

  /**
   * @dev transferFrom allows a sender to spend mikancoin on the from address's behalf
   * pending approval
   * @param _from : The account from which to withdraw tokens
   * @param _to : The address of the recipient
   * @param _tokens : Number of tokens to transfer
   */
  function transferFrom(address _from, address _to, uint _tokens) public
  validDestination(_to)
  returns (bool success) {
    require(_tokens <= allowance[_from][msg.sender]);
    allowance[_from][msg.sender] -= _tokens;
    _transfer(_from, _to, _tokens);
    return true;
  }

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  modifier validDestination( address _to ) {
    require(_to != address(0x0));
    require(_to != address(this));
    _;
  }
}
