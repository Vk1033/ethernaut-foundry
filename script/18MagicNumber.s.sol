// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MagicNum} from "src/18MagicNumber.sol";

contract MagicNumberAttack is Script {
    function run() external returns (address deployed) {
        MagicNum target = MagicNum(0xfBf2c243754C419950E7428e31a2A254B234d6D3);

        vm.startBroadcast();

        // Minimal Huff/Yul contract bytecode (constructor + runtime)
        bytes memory bytecode = hex"60088060093d393df3602a5f5260205ff3";

        assembly {
            // deploy contract
            deployed := create(0, add(bytecode, 0x20), mload(bytecode)) // mload(bytecode) = 17 bytes = 0x11
            if iszero(extcodesize(deployed)) { revert(0, 0) }
        }

        // Log the deployed address
        console.log("Deployed contract at:", deployed);

        // Get runtime code size
        uint256 size;
        assembly {
            size := extcodesize(deployed)
        }
        console.log("Contract runtime size (bytes):", size); // 8 bytes

        // Interact with the target contract
        target.setSolver(deployed);

        vm.stopBroadcast();
    }
}
