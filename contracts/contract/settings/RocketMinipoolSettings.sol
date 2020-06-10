pragma solidity 0.6.8;

// SPDX-License-Identifier: GPL-3.0-only

import "../RocketBase.sol";
import "../../interface/settings/RocketMinipoolSettingsInterface.sol";
import "../../lib/SafeMath.sol";

// Network minipool settings

contract RocketMinipoolSettings is RocketBase, RocketMinipoolSettingsInterface {

    // Libs
    using SafeMath for uint;

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) public {
        // Set version
        version = 1;
        // Initialize settings on deployment
        if (!getBoolS("settings.minipool.init")) {
            // Apply settings
            setLaunchBalance(32 ether);
            setLaunchTimeout(5760); // ~24 hours
            // Settings initialized
            setBoolS("settings.minipool.init", true);
        }
    }

    // Balance required to launch minipool
    function getLaunchBalance() override public view returns (uint256) {
        return getUintS("settings.minipool.launch.balance");
    }
    function setLaunchBalance(uint256 _value) public onlySuperUser {
        setUintS("settings.minipool.launch.balance", _value);
    }

    // Required node deposit amounts
    function getFullDepositNodeAmount() override public view returns (uint256) {
        return getLaunchBalance();
    }
    function getHalfDepositNodeAmount() override public view returns (uint256) {
        return getLaunchBalance().div(2);
    }
    function getEmptyDepositNodeAmount() override public view returns (uint256) {
        return 0;
    }

    // Required user deposit amounts
    function getFullDepositUserAmount() override public view returns (uint256) {
        return getLaunchBalance().div(2);
    }
    function getHalfDepositUserAmount() override public view returns (uint256) {
        return getLaunchBalance().div(2);
    }
    function getEmptyDepositUserAmount() override public view returns (uint256) {
        return getLaunchBalance();
    }

    // Timeout period in blocks for prelaunch minipools to launch
    function getLaunchTimeout() override public view returns (uint256) {
        return getUintS("settings.minipool.launch.timeout");
    }
    function setLaunchTimeout(uint256 _value) public onlySuperUser {
        setUintS("settings.minipool.launch.timeout", _value);
    }

}
