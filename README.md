# ETH-AVAX-MODULE-4-PROJECT
## Project Description 
For this project, we will write an ERC20-compliant smart contract to create your own token on a local Hardhat network. To get started, we will use the Hardhat boilerplate project that is shown in the Hardhat Website itself, which provides a solid foundation. Once you have set up the Hardhat project, you can begin writing your smart contract. The contract should be compatible with Remix, allowing easy interaction. As the contract owner, you should have the ability to mint tokens to a specified address. Additionally, any user should be able to burn and transfer tokens to other addresses.

## Deployment Instructions 
1. open a command prompt and run this command: $ mkdir avalanche-project to create a named "avalanche-project" in the location.
2. change the directory with this command: $ cd avalanche-project
3. run this command to create a new package.json: $$ npm init -y
4. install the hardhat development environment: $ npm install --save-dev hardhat
5. to run the hardhat, run this command: $ npx hardhat
  5.1 select the create a javascript project in order to generate a hardhat.config.js
6. to install the toolbox plugin of hardhat: $ npm i --save-dev @nomicfoundation/hardhat-toolbox
7. Install the OpenZeppelin Contracts library as a dependency by executing the following command: npm install @openzeppelin/contracts
8. Edit your hardhat.config.js
### Token.sol
```solidity
require("@nomicfoundation/hardhat-toolbox");
const FORK_FUJI = false;
const FORK_MAINNET = false;
let forkingData = undefined;
if (FORK_MAINNET) {
  forkingData = {
    url: "https://api.avax.network/ext/bc/C/rpcc",
  };
}
if (FORK_FUJI) {
  forkingData = {
    url: "https://api.avax-test.network/ext/bc/C/rpc",
  };
}
module.exports = {
  solidity: "0.8.18",
  networks: {
    hardhat: {
      gasPrice: 225000000000,
      chainId: !forkingData ? 43112 : undefined,
      forking: forkingData
    },
    fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43113,
      accounts: [
        // INSERT THE METAMASK PRIVATE KEY HERE 
      ]
    },
    mainnet: {
      url: 'https://api.avax.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43114,
      accounts: [
        // INSERT THE METAMASK PRIVATE KEY HERE
      ]
    }
  }
}
```
9. Also, edit the deploy.js, can be found in the scripts folder
### deploy.js
```solidity
const hre = require("hardhat");
async function main() {
	
  const contractName == "CONTRACT_NAME HERE" 
  const contract = await hre.ethers.deployContract(contractName);
  await contract.waitForDeployment();
  console.log(`Contract Deployed to address ${await contract.getAddress()}`);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```
10. Create your own API key from the Snowtrace, then add it to your hardhat.config.js
### hardhat.config.js
```solidity
module.exports = {
  // ...rest of the config...
  etherscan: {
    apiKey: "INSERT YOUR API KEY HERE",
  },
};
```
11. Set up a Avalanche network in your Metamask by adding a new network with these details (Network Name: Avalanche Fuji C-Chain New RPC URL: https://api.avax-test.network/ext/bc/C/rpc ChainID: 43113 Symbol: AVAX Explorer: https://testnet.snowtrace.io/)
12. Go to the Avalanche Testnet Faucet website, and request 2 AVAX to your wallet account in order for the contract to run.
13. run the script with the fuji network with this command: $ npx hardhat run scripts/deploy.js --network fuji
14. verify the smart contract address you deployed by this command: $ npx hardhat verify (INSERT CONTRACT ADDRESS) --network fuji
15. Then go to the remix ethereum website, and copy the Degen.sol
16. In the deployment tab, there is an "At Address" tab there and copy the contract address there as well.
17. You can now do the functions!
### Degen.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
contract DegenToken is ERC20, Ownable, ERC20Burnable {
    mapping(address => bool) private _banned;
    event MintToken(address indexed to, uint256 value);
    event BurnToken(address indexed from, uint256 value);
    event RedeemGameReward(address indexed player, string itemName);
    constructor() ERC20("Degen", "DGN") {}
    function mint(address to, uint256 amount) external onlyOwner  {
        _mint(to, amount);
        emit MintToken(to, amount);
    }
    function burntokens(uint256 amount) external {
        require(balanceOf(msg.sender)>= amount, "You do not have enough Tokens in your account");
        _burn(msg.sender, amount);
        emit BurnToken(msg.sender, amount);
    }
    function RewardsStore() public pure returns(string memory) {
            return "1. Expensive Outfit (value = 500 Degen)\n2. Strong Sword (value = 300 Degen)\n3. Big Shield (value = 100 Degen)";
        }
    function redeem(uint256 choice) external {
        require(choice <= 3, "Invalid selection");
        if (choice == 1) {
            require(balanceOf(msg.sender) >= 500, "Insufficient balance");
            approve(msg.sender, 500);
            transferFrom(msg.sender, owner(), 500);
            emit RedeemGameReward(msg.sender, "Expensive Outfit");
        } else if (choice == 2) {
            require(balanceOf(msg.sender) >= 300, "Insufficient balance");
            approve(msg.sender, 300);
            transferFrom(msg.sender, owner(), 300);
            emit RedeemGameReward(msg.sender, "Strong Sword");
        } else if (choice == 3) {
            require(balanceOf(msg.sender) >= 100, "Insufficient balance");
            approve(msg.sender, 100);
            transferFrom(msg.sender, owner(), 100);
            emit RedeemGameReward(msg.sender, "Big Shield");
        }
    }
    function checkBalance() external view returns(uint){
           return balanceOf(msg.sender);
    }
    function transfer(address reciever, uint256 amount) public override returns (bool) {
        return super.transfer(reciever, amount);
    }
    function transferFrom(address sender, address reciever, uint256 amount) public override returns (bool) {
        approve(msg.sender, amount);
        return super.transferFrom(sender, reciever, amount);
    }
}
```
