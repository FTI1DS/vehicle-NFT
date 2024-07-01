// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/VehicleNFT.sol";

contract DeployVehicleNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        VehicleNFT vehicleNFT = new VehicleNFT();

        console.log("VehicleNFT deployed to:", address(vehicleNFT));

        vm.stopBroadcast();
    }
}

