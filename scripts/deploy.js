const { ethers } = require("hardhat");

async function main() {
  const DAONameService = await ethers.getContractFactory("DAONameService");
  const daoNameService = await DAONameService.deploy();

  await daoNameService.deployed();

  console.log("DAONameService contract deployed to:", daoNameService.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
