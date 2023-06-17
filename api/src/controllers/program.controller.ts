import { NextFunction, Request, Response } from "express";
import { asyncWrap } from "../middlewares/async.middleware";
import { throwError } from "../helpers/errorHandler.helper";
import {
  GetProgramByAddressRequest,
  PostCreateProgramRequest,
  PostJoinProgramByAddressRequest,
} from "../schemas/program.schema";
import {
  createProgramFunctionSignature,
  getAllPrograms,
  getProgram,
} from "../services/ethers.service";
import { UNITI_CONTRACT_ADDRESS } from "../config/contracts.config";
import { generateERC721TokenURI } from "../services/weaveDb.service";

export const postCreateProgram = asyncWrap(
  async (
    req: Request<{}, {}, PostCreateProgramRequest>,
    res: Response,
    _next: NextFunction
  ) => {
    try {
      const { name, symbol, description } = req.body;
      //  implement FILE too --lucifer
      const tokenURI = await generateERC721TokenURI(name, symbol, description);
      //  implement logic --megabyte file thing we will do together
      const functionSignature = createProgramFunctionSignature(
        name,
        symbol,
        tokenURI
      );
      const txnData = {
        to: UNITI_CONTRACT_ADDRESS,
        data: functionSignature,
      };
      res.status(201).json({ txnData });
    } catch (error) {
      throwError(500, error);
    }
  }
);

export const getPrograms = asyncWrap(
  async (req: Request, res: Response, _next: NextFunction) => {
    try {
      //  implement logic --megabyte
      const { programAddresses, programName, imageURLs } =
        await getAllPrograms();
      res.status(201).json({ programAddresses, programName, imageURLs });
    } catch (error) {
      throwError(500, error);
    }
  }
);

export const getProgramByAddress = asyncWrap(
  async (
    req: Request<GetProgramByAddressRequest>,
    res: Response,
    _next: NextFunction
  ) => {
    try {
      const programAddress = req.params.programAddress;
      const { name, description, campaignURI } = await getProgram(
        programAddress
      );

      res.status(201).json({ name, description, campaignURI });
    } catch (error) {
      throwError(500, error);
    }
  }
);

export const postJoinProgramByAddress = asyncWrap(
  async (
    req: Request<{}, {}, PostJoinProgramByAddressRequest>,
    res: Response,
    _next: NextFunction
  ) => {
    try {
      const { programAddress, walletAddress } = req.body;
      //  implement logic --megabyte

      res.status(201).json({ programAddress, walletAddress });
    } catch (error) {
      throwError(500, error);
    }
  }
);
