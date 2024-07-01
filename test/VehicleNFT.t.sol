// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/VehicleNFT.sol";

contract VehicleNFTTest is Test {
    VehicleNFT vehicleNFT;
    address addr1 = address(0x1);
    address addr2 = address(0x2);
    address addr3 = address(0x3);

    function setUp() public {
        vehicleNFT = new VehicleNFT();
    }

    function testMint() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        assertEq(vehicleNFT.ownerOf(0), addr1);
    }

    function testMintDuplicateTokenURI() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr2);
        vm.expectRevert("ERC721: token URI already used");
        vehicleNFT.mint(addr2, "https://example.com/nft/1");
    }

    function testUpdateMileage() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr1);
        vehicleNFT.updateMileage(0, 15000);
        (uint256 mileage,,) = vehicleNFT.getVehicleData(0);
        assertEq(mileage, 15000);
    }

    function testUpdateMileageCannotDecrease() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr1);
        vehicleNFT.updateMileage(0, 15000);
        vm.prank(addr1);
        vm.expectRevert("New mileage must be greater than or equal to current mileage");
        vehicleNFT.updateMileage(0, 14000);
    }

    function testAddServiceRecord() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        uint256 currentTimestamp = block.timestamp;
        vm.prank(addr1);
        vehicleNFT.addServiceRecord(0, 10000, currentTimestamp, "Oelwechsel");

        (, VehicleNFT.ServiceRecord[] memory services,) = vehicleNFT.getVehicleData(0);
        assertEq(services.length, 1);
        assertEq(services[0].mileage, 10000);
        assertEq(services[0].timestamp, currentTimestamp);
        assertEq(services[0].description, "Oelwechsel");
    }

    function testAddAccidentRecord() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        uint256 currentTimestamp = block.timestamp;
        vm.prank(addr1);
        vehicleNFT.addAccidentRecord(0, 12000, currentTimestamp, "Kleiner Unfall hinten links");

        (,, VehicleNFT.AccidentRecord[] memory accidents) = vehicleNFT.getVehicleData(0);
        assertEq(accidents.length, 1);
        assertEq(accidents[0].mileage, 12000);
        assertEq(accidents[0].timestamp, currentTimestamp);
        assertEq(accidents[0].description, "Kleiner Unfall hinten links");
    }

    function testExists() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        assertTrue(vehicleNFT.exists(0));
        assertFalse(vehicleNFT.exists(1));
    }

    // Additional edge cases

    function testMintToZeroAddress() public {
        vm.expectRevert("ERC721: mint to the zero address");
        vehicleNFT.mint(address(0), "https://example.com/nft/2");
    }

    function testMintDuplicateToken() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.expectRevert("ERC721: token URI already used");
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
    }

    function testUpdateMileageNonexistentToken() public {
        vm.expectRevert(abi.encodeWithSelector(
            bytes4(keccak256("ERC721NonexistentToken(uint256)")),
            1
        ));
        vehicleNFT.updateMileage(1, 15000);
    }

    function testAddServiceRecordNonexistentToken() public {
        vm.expectRevert(abi.encodeWithSelector(
            bytes4(keccak256("ERC721NonexistentToken(uint256)")),
            1
        ));
        vehicleNFT.addServiceRecord(1, 10000, block.timestamp, "Oelwechsel");
    }

    function testAddAccidentRecordNonexistentToken() public {
        vm.expectRevert(abi.encodeWithSelector(
            bytes4(keccak256("ERC721NonexistentToken(uint256)")),
            1
        ));
        vehicleNFT.addAccidentRecord(1, 12000, block.timestamp, "Kleiner Unfall hinten links");
    }

    function testGetVehicleDataNonexistentToken() public {
        vm.expectRevert("ERC721: operator query for nonexistent token");
        vehicleNFT.getVehicleData(1);
    }

    function testUnauthorizedUpdateMileage() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr2);
        vm.expectRevert("Only the owner can modify the token");
        vehicleNFT.updateMileage(0, 20000);
    }

    function testUnauthorizedAddServiceRecord() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr2);
        vm.expectRevert("Only the owner can modify the token");
        vehicleNFT.addServiceRecord(0, 10000, block.timestamp, "Oelwechsel");
    }

    function testUnauthorizedAddAccidentRecord() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr2);
        vm.expectRevert("Only the owner can modify the token");
        vehicleNFT.addAccidentRecord(0, 12000, block.timestamp, "Kleiner Unfall hinten links");
    }

    function testTransfer() public {
        vm.prank(addr1);
        vehicleNFT.mint(addr1, "https://example.com/nft/1");
        vm.prank(addr1);
        vehicleNFT.safeTransferFrom(addr1, addr2, 0);
        assertEq(vehicleNFT.ownerOf(0), addr2);

        vm.prank(addr2);
        vehicleNFT.updateMileage(0, 20000);
        (uint256 mileage,,) = vehicleNFT.getVehicleData(0);
        assertEq(mileage, 20000);

        vm.prank(addr1);
        vm.expectRevert("Only the owner can modify the token");
        vehicleNFT.updateMileage(0, 25000);
    }
}
