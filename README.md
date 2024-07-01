## Vehicle-NFT

## Steps taken to create the project:


1. curl -L https://foundry.paradigm.xyz | bash
2. mkdir foundry
3. cd foundry
4. foundryup
5. forge init vehilce-nft --no-git (or setting up git account)
6. cd vehicle-nft
7. cd lib/
8. git clone https://github.com/OpenZeppelin/openzeppelin-contracts
9. delete src/Counter.sol, test/Counter.test.sol, script/Counter.s.sol

## Compile the contract
forge build

## Test the Contract with testfile
forge test


## Steps for deployment and verification:
Deploy the contract:
forge script script/VehicleNFT.s.sol --rpc-url https://geneva-rpc.moonchain.com --broadcast

create a flattened contract file for verifing:
forge flatten src/VehicleNFT.sol > flattened_VehicleNFT.sol

verify the contract:
1. open contract on geneva explorer, click on contract > Verify & publish
2. choose 0.8.26 compiler, evm:istanbul, copy the flattened_VehicleNFT.sol-Code into the textfield and click on Verify
