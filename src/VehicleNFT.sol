// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VehicleNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    struct ServiceRecord {
        uint256 mileage;
        uint256 timestamp;
        string description;
    }

    struct AccidentRecord {
        uint256 mileage;
        uint256 timestamp;
        string description;
    }

    struct VehicleData {
        uint256 mileage;
        ServiceRecord[] services;
        AccidentRecord[] accidents;
    }

    mapping(uint256 => VehicleData) public vehicleData;
    mapping(string => bool) private usedTokenURIs;

    event VehicleDataUpdated(uint256 tokenId, uint256 mileage);
    event ServiceRecordAdded(uint256 tokenId, uint256 mileage, uint256 timestamp, string description);
    event AccidentRecordAdded(uint256 tokenId, uint256 mileage, uint256 timestamp, string description);

    constructor() ERC721("VehicleNFT", "VNFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function mint(address to, string memory tokenURI) public {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!usedTokenURIs[tokenURI], "ERC721: token URI already used");
        uint256 tokenId = tokenCounter;
        require(!_exists(tokenId), "ERC721: token already minted");
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        usedTokenURIs[tokenURI] = true;
        tokenCounter++;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can modify the token");
        _;
    }

    function updateMileage(uint256 tokenId, uint256 mileage) public onlyTokenOwner(tokenId) {
        require(mileage >= vehicleData[tokenId].mileage, "New mileage must be greater than or equal to current mileage");
        vehicleData[tokenId].mileage = mileage;
        emit VehicleDataUpdated(tokenId, mileage);
    }

    function addServiceRecord(uint256 tokenId, uint256 mileage, uint256 timestamp, string calldata description) public onlyTokenOwner(tokenId) {
        vehicleData[tokenId].services.push(ServiceRecord(mileage, timestamp, description));
        emit ServiceRecordAdded(tokenId, mileage, timestamp, description);
    }

    function addAccidentRecord(uint256 tokenId, uint256 mileage, uint256 timestamp, string calldata description) public onlyTokenOwner(tokenId) {
        vehicleData[tokenId].accidents.push(AccidentRecord(mileage, timestamp, description));
        emit AccidentRecordAdded(tokenId, mileage, timestamp, description);
    }

    function getVehicleData(uint256 tokenId) public view returns (uint256, ServiceRecord[] memory, AccidentRecord[] memory) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        VehicleData storage data = vehicleData[tokenId];
        return (data.mileage, data.services, data.accidents);
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    // Internally used method to check if a token exists
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
}
