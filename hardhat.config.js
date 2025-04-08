require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

const SEPOLIA_RPC_URL = process.env.INFURA_PROJECT_ID
  ? `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`
  : "https://rpc.sepolia.dev";

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
    },
    localhost: {
      chainId: 31337,
    },
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 11155111,
      gas: 5000000,
      gasPrice: 20000000000,
    },
  },
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  mocha: {
    timeout: 40000,
    useColors: true,
    reporter: "spec",
    bail: true,
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
