pragma solidity ^0.4.11;

import "./MiniMe.sol";

contract Owned {
    modifier onlyOwner { require (msg.sender == owner); _; }
    
    address public owner;

    /// @notice The Constructor assigns the message sender to be `owner`
    function Owned() { owner = msg.sender;}

    /// @notice `owner` can step down and assign some other address to this role
    /// @param _newOwner The address of the new owner. 0x0 can be used to create
    ///  an unowned neutral vault, however that cannot be undone
    function changeOwner(address _newOwner) onlyOwner {
        owner = _newOwner;
    }
}

contract GlobalMeetup is Controller, Owned {
    
    MiniMeToken public tokenContract; // The new token for this particular Meetup. In this case the 1st, and global one.

    modifier onlyOwner { require (msg.sender == Owned.owner); _; }

    /// Seeing as this token is handed out for free and has far more to do with communal signalling
    /// and community development, there is no funding required. Therefore, all the start and end time stuff and
    /// cap on fundraising from here is not required: https://github.com/Giveth/minime/blob/master/contracts/SampleCampaign-TokenController.sol
    /// The intention here is to have a continuous token supply which can be used to in tokens on demand for all the cool
    /// new people attending Meetups around the world.
    /// 
    /// @param _tokenAddress Address of the token contract that this contract controls.

    function GlobalMeetup (address _tokenAddress) {
        tokenContract = MiniMeToken(_tokenAddress);
    }

    /// @notice Notifies the controller about a transfer. For the MeetupToken all
    ///  transfers are allowed by default and no extra notifications are needed
    /// @param _from The origin of the transfer
    /// @param _to The destination of the transfer
    /// @param _amount The amount of the transfer
    /// @return False if the controller does not authorize the transfer

    /// TODO: are the unused variables here an issue to consider?
    function onTransfer(address _from, address _to, uint _amount) returns(bool) {
        return true;
    }

    /// @notice Notifies the controller about an approval. For this MeetupToken all
    ///  approvals are allowed by default and no extra notifications are needed
    /// @param _owner The address that calls `approve()`
    /// @param _spender The spender in the `approve()` call
    /// @param _amount The amount in the `approve()` call
    /// @return False if the controller does not authorize the approval

    /// TODO: same as above.
    function onApprove(address _owner, address _spender, uint _amount) returns (bool) {
        return true;
    }

    /// @notice Generates tokens when called by the Owner of this contract. I need to think
    /// more about the best way actually to implement this. I don't want to force people to pay
    /// Ether in order to generate tokens as this goes against the free-and-walways-will-be nature
    /// of what I'm trying to build. At the same time, it would be awesome to allow people to call 
    /// the function themselves as this both creates another educational opportunity and lowers the 
    /// gas costs for us.
    /// @param _owner Address of the owner of this Controller contract
    /// @param _amount Amount of tokens to be made with this call. The thinking being that it might be 
    /// cheaper to create them in batches and distribute them from the _owner address.
    function generateTokens(address _owner, uint _amount) onlyOwner returns (bool) {
        // TODO: Extra check. What actually is the effect of this though? Why is is not capitalised?
        require(tokenContract.controller() != 0); 

        require(tokenContract.generateTokens(_owner, _amount));

        tokensMinted(_amount);

        return true;
    }

    event tokensMinted(uint _amount);
}

/// Do I need a destroyTokens() function? What purpose would this serve in the context of the MeetupToken?