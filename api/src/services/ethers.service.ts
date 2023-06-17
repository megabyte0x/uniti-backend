import ethers from "ethers";
import {
  UNITI_CONTRACT_ABI,
  UNITI_CONTRACT_ADDRESS,
  UNITI_PROGRAM_CONTRACT_ABI,
} from "../config/contracts.config";

const unitiContract = new ethers.Contract(
  UNITI_CONTRACT_ADDRESS,
  UNITI_CONTRACT_ABI
);

export const createProgramFunctionSignature = (
  name: string,
  symbol: string,
  tokenURI: string
) => {
  const functionSignature = unitiContract.interface.encodeFunctionData(
    "createProgram",
    [name, symbol, tokenURI]
  );
  return functionSignature;
};

export const getAllPrograms = async () => {
  try {
    const programAddresses =
      (await unitiContract.getPrograms()) as Array<string>;
    const programName: Array<string> = [];
    const imageURLs: Array<string> = [];

    programAddresses.forEach(async (programAddress) => {
      const programContract = new ethers.Contract(
        programAddress,
        UNITI_PROGRAM_CONTRACT_ABI
      );
      const name = await programContract.name();
      const tokenURI = await programContract.tokenURI(0);
      programName.push(name);
      imageURLs.push(tokenURI);
    });
    return { programAddresses, programName, imageURLs };
  } catch (error) {
    throw error;
  }
};
