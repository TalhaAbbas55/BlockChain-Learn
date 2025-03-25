require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id (for Ganache local blockchain)
    },
    sepolia: {
      provider: () =>
        new HDWalletProvider(
          process.env.PRIVATE_KEY,
          `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`
        ),
      network_id: 11155111, // Sepolia network ID
      gas: 700000, // Set a little higher than 479770 for safety
      gasPrice: 15000000000, // 15 Gwei
    },
  },
  compilers: {
    solc: {
      version: "0.8.20", // Use Solidity 0.8.20
    },
  },
};
