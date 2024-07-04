## Vehicle-NFT

## Steps taken to create the project from zero:
### Step 1
Install Foundry
```sh
curl -L https://foundry.paradigm.xyz | bash
```

Warning: Depending on your OS, you might encounter one of these two warnings:

macOS:
Warning: libusb not found. You may need to install it manually on macOS via Homebrew (brew install libusb).
Detected your preferred shell is zsh and added foundryup to PATH. Run 'source /Users/sanghamitrabhowmick/.zshenv' or start a new terminal session to use foundryup. Then, simply run 'foundryup' to install Foundry.

Solution:
```sh
brew install libusb
source /Users/USERNAME/.zshenv
foundryup
```
Debian/bash:
Detected your preferred shell is bash and added foundryup to PATH.
Run 'source /home/ubuntu/.bashrc' or start a new terminal session to use foundryup. Then, simply run 'foundryup' to install Foundry.

Solution:
```sh
source /home/USERNAME/.bashrc
```
### Step 2
Setting up the project folder
```sh
mkdir foundry
cd foundry
foundryup
forge init vehilce-nft --no-git (or setting up git account)
cd vehicle-nft
delete src/Counter.sol, test/Counter.t.sol, script/Counter.s.sol
```
### Step 3 
Install the OpenZeppelin-Dependencies
```sh
cd lib/
git clone https://github.com/OpenZeppelin/openzeppelin-contracts
```
### Step 4
Create the contracts file: src/VehicleNFT.sol, the test file: test/VehicleNFT.t.sol, the deployment script: script/Vehicle.s.sol, and the interaction script: script/InteractVehicleNFT.s.sol.

## Steps to Deploy the Contract from a Cloned Repository
### Step 1
Clone the Repository
```sh
git clone -b master https://github.com/FTI1DS/vehicle-NFT.git
cd vehicle-NFT
```
### Step 2
Install Foundry on the machine

To install Foundry correctly, follow step 1 of 'Steps to create the Project from zero'

## Compile the contract
```sh
forge build
```
## Test the Contract with testfile
```sh
forge test
```

## Steps for deployment and verification:
Important:
Enter your private key into the .env file like this example. It's important to add 0x before the key. Example: PRIVATE_KEY=0x5323614sdkjbrrkjq3...

Deploy the contract:
forge script script/VehicleNFT.s.sol --rpc-url https://geneva-rpc.moonchain.com --broadcast

create a flattened contract file for verifing:
forge flatten src/VehicleNFT.sol > flattened_VehicleNFT.sol

verify the contract:
1. open contract on geneva explorer, click on contract > Verify & publish
2. choose 0.8.26 compiler, evm:istanbul, copy the flattened_VehicleNFT.sol-Code into the textfield and click on Verify

## Interact with deployed contract with foundry-script
1. Change Contract-address in script/InteractVehicleNFT.s.sol
2. ``` forge script script/InteractVehicleNFT.s.sol --rpc-url  https://geneva-rpc.moonchain.com --private-key <PRIVATE_KEY> --broadcast ```

## Interact with deployed contract with foundry-script
1. Change Contract-address in script/InteractVehicleNFT.s.sol
2. forge script script/InteractVehicleNFT.s.sol --rpc-url  https://geneva-rpc.moonchain.com --private-key <PRIVATE_KEY> --broadcast
