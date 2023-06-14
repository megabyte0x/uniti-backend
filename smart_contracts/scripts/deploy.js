const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  try {
    const UNITI_CONTRACT = await ethers.getContractFactory("Uniti");
    const uniti_contract = await UNITI_CONTRACT.deploy();
    await uniti_contract.deployed();
    console.log("Contract address:", uniti_contract.address);

    console.log("Sleeping.....");
    await sleep(40000);

    await hre.run("verify:verify", {
      address: uniti_contract.address,
    });
  } catch (error) {
    console.error(error);
  }
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});