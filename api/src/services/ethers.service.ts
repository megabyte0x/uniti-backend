import ethers from "ethers";
import {
  UNITI_CAMPAIGN_CONTRACT_ABI,
  UNITI_CONTRACT_ABI,
  UNITI_CONTRACT_ADDRESS,
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
    const programAddresses = (await unitiContract.getPrograms()) as string[];
    const programName: string[] = [];
    const imageURLs: string[] = [];

    programAddresses.forEach(async (programAddress) => {
      const { name, tokenURI } = await unitiContract.getProgramDetails(
        programAddress
      );

      //! TODO: Implement a function to get the Image URL through fetchting the data of the tokenURI
      programName.push(name);
      imageURLs.push(tokenURI);
    });
    return { programAddresses, programName, imageURLs };
  } catch (error) {
    throw error;
  }
};

export const getProgram = async (programAddress: string) => {
  try {
    const { name, tokenURI } = await unitiContract.getProgramDetails(
      programAddress
    );

    //! TODO: Implement a function to get the Image URL through fetchting the data of the tokenURI
    const description = tokenURI.description;

    const campaginAddress = await unitiContract.getCampaignAddress();
    const campaignContract = new ethers.Contract(
      campaginAddress,
      UNITI_CAMPAIGN_CONTRACT_ABI
    );
    const campaignURI = await campaignContract.uri();
    //! TODO: Implement a function to get the Image URL, Name through fetchting the data of the tokenURI

    return { name, description, campaignURI };
  } catch (error) {
    throw error;
  }
};

export const createCampaign = async (
  tokenURI: string,
  programAddress: string
) => {
  try {
    const campaingAddress = await unitiContract.createCampaign(
      tokenURI,
      programAddress
    );
    return campaingAddress;
  } catch (error) {
    throw error;
  }
};
