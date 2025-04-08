require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  mocha: {
    useColors: true,
    reporter: "spec",
    bail: true,
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // For Ganache
    },
    sepolia: {
      provider: () =>
        new HDWalletProvider(
          process.env.PRIVATE_KEY,
          `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`
        ),
      network_id: 11155111,
      gas: 5000000, // 3,000,000 gas limit
      gasPrice: 20000000000, // 10 Gwei
    },
  },
  compilers: {
    solc: {
      version: "0.8.0", // Use Solidity 0.8.29
      settings: { optimizer: { enabled: true, runs: 200 } },
    },
  },
};
