// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/VehicleNFT.sol";

contract InteractWithVehicleNFT is Script {
    function run() external {
        vm.startBroadcast();

        VehicleNFT vehicleNFT = VehicleNFT(0x7F7F8833212158d50722dDA49d2d794B583B8f6b);

        // Mint a new NFT
        vehicleNFT.mint(msg.sender, "https://example.com/nft/1");

        // Update mileage
        vehicleNFT.updateMileage(0, 15000);

        // Add service record
        vehicleNFT.addServiceRecord(0, 10000, block.timestamp, "Oelwechsel");

        // Add accident record
        vehicleNFT.addAccidentRecord(0, 12000, block.timestamp, "Kleiner Unfall hinten links");

        vm.stopBroadcast();
    }
}