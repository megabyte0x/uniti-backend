require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  network: {
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
    }
  }
};