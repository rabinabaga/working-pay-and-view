const hre = require("hardhat");

async function main() {
  // Get the contract factory for PaymentRecorder
  const PaymentRecorder = await hre.ethers.getContractFactory(
    "PaymentRecorder"
  );

  // Deploy the PaymentRecorder contract
  const paymentRecorder = await PaymentRecorder.deploy();

  // Wait for the contract to be deployed
  await paymentRecorder.waitForDeployment();

  // Log the deployed contract address
  console.log("PaymentRecorder deployed to:", paymentRecorder.target);
}

// Run the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
