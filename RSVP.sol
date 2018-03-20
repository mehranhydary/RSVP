pragma solidity ^0.4.18;

contract RSVP {
    
    uint256 public minDeposit; // variable to hold the required minimum deposit
    address public owner; // variable to hold who the owner of the contract is (only the owner can refund the deposit - this stops people from calling the refund function even if they are not at the event)
    
    mapping (address => uint256) public balances; // mapping that stores who and how much ETH was put into the contract
    
    event Staked(address indexed beneficiary, uint256 value); // Log of the deposit
    event Redeemed(address indexed recipient, uint256 value); // Log of the redemption
    
    
    // RSVP constructor - this can only be called once on creation (usually used to set the initial state of the contract)
    function RSVP(uint256 _minDeposit) public {
        require(_minDeposit > 0); // making sure the deposit is not 0
        owner = msg.sender; // setting the owner of the contract to the creator of the contract
        minDeposit = _minDeposit; // setting the minimum deposit amount
    }   
    
    // This will fire when someone sends ETH to this contract
    function () external payable { 
        rsvp(); //Give it a function that you want to execute
    }
    
    // The function we want executed when someone sends ETH to this contract
    function rsvp() internal {
        require(msg.value >= minDeposit); // acts like a modifier to make sure it is greater or equal to the min
        
        balances[msg.sender] = balances[msg.sender] + msg.value; // update our mapping to remember how much this user sent to the contract
        
        emit Staked(msg.sender, msg.value); // emit an event to record in event log
    }
    
    //this will refund the deposited ETH which can only be executed by the contract owner or meetup organizer
    function refund(address _recipient) public {
        require(owner == msg.sender); // making sure the initiator is the owner
        require(_recipient != address(0)); // making sure the recipient is not the 0 address
        
        _recipient.transfer(balances[_recipient]); // return staked ETH to recipient
        
        emit Redeemed(_recipient, balances[_recipient]); // emit abn event to record to event log
        
        balances[_recipient] = 0; // zero out our mapping after sending the ETH
    }
}
