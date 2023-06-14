import { NextFunction, Request, Response } from "express";
import { asyncWrap } from "../middlewares/async.middleware";
import { throwError } from "../helpers/errorHandler.helper";
import { GetProgramByAddressRequest, GetProgramsRequest, PostCreateProgramRequest, PostJoinProgramByAddressRequest } from "../schemas/program.schema";


export const postCreateProgram = asyncWrap(async (req: Request<{}, {}, PostCreateProgramRequest>, res: Response, _next: NextFunction) => {
    try {
        const { walletAddress, name, description } = req.body;
        //  implement FILE too --lucifer

        //  implement logic --megabyte file thing we will do together

        res.status(201).json({ walletAddress, name, description })
    } catch (error) {
        throwError(500, error)
    }
})

export const getPrograms = asyncWrap(async (req: Request<{}, GetProgramsRequest>, res: Response, _next: NextFunction) => {
    try {
        const { walletAddress } = req.query
        //  implement logic --megabyte

        res.status(201).json({ walletAddress })
    } catch (error) {
        throwError(500, error)
    }
})

export const getProgramByAddress = asyncWrap(async (req: Request<GetProgramByAddressRequest>, res: Response, _next: NextFunction) => {
    try {
        const programAddress = req.params.programAddress
        //  implement logic --megabyte

        res.status(201).json({ programAddress })
    } catch (error) {
        throwError(500, error)
    }
})

export const postJoinProgramByAddress = asyncWrap(async (req: Request<{}, {}, PostJoinProgramByAddressRequest>, res: Response, _next: NextFunction) => {
    try {
        const { programAddress, walletAddress } = req.body
        //  implement logic --megabyte

        res.status(201).json({ programAddress, walletAddress })
    } catch (error) {
        throwError(500, error)
    }
})
