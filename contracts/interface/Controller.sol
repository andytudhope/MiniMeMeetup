pragma solidity ^0.4.11;

/// @dev The token controller contract must implement these functions
contract Controller {
    /// @notice Notifies the controller about a token transfer allowing the
    ///  controller to react if desired
    /// @param _from The origin of the transfer
    /// @param _to The destination of the transfer
    /// @param _amount The amount of the transfer
    /// @return False if the controller does not authorize the transfer
    function onTransfer(address _from, address _to, uint _amount) returns(bool);

    /// @notice Notifies the controller about an approval allowing the
    ///  controller to react if desired
    /// @param _owner The address that calls `approve()`
    /// @param _spender The spender in the `approve()` call
    /// @param _amount The amount in the `approve()` call
    /// @return False if the controller does not authorize the approval
    function onApprove(address _owner, address _spender, uint _amount) returns(bool);

    /// @notice Notifies the controller about a token minting event allowing the controller
    /// to react if desired.
    /// @param _owner The address that calls `generateTokens()`
    /// @param _amount The amount in the `generateTokens()` call
    function generateTokens(address _owner, uint _amount) returns (bool);
}

/// I have removed the proxyPayment() route here and added the token generation one. Is this good enough?