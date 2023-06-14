import { NextFunction, Request, Response } from "express";
import { asyncWrap } from "../middlewares/async.middleware";
import { throwError } from "../helpers/errorHandler.helper";
import { ParamsRequest, PostCreateCampaignRequest } from "../schemas/campaign.schema";


export const postCreateCampaign = asyncWrap(async (req: Request<ParamsRequest, {}, PostCreateCampaignRequest>, res: Response, _next: NextFunction) => {
    try {
        const { name, description, amount } = req.body;
        const { programAddress } = req.params
        console.log(req.params)
        //  implement FILE too --lucifer

        //  implement logic --megabyte file thing we will do together

        res.status(201).json({ amount, programAddress, name, description })
    } catch (error) {
        throwError(500, error)
    }
})