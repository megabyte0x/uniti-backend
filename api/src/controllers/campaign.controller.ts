import { NextFunction, Request, Response } from "express";
import { asyncWrap } from "../middlewares/async.middleware";
import { throwError } from "../helpers/errorHandler.helper";
import { CampaignParamsRequest, PostCampaignSubmissionRequest, PostCampaignSubmitRequest, PostCreateCampaignRequest } from "../schemas/campaign.schema";
import { CustomRequest } from "../routes";


export const postCreateCampaign = asyncWrap(async (req: Request<CampaignParamsRequest, {}, PostCreateCampaignRequest>, res: Response, _next: NextFunction) => {
    try {
        const { name, description, amount } = req.body;
        const programAddress = (req as CustomRequest).programAddress
        //  implement FILE too --lucifer

        //  implement logic --megabyte file thing we will do together

        res.status(201).json({ amount, programAddress, name, description })
    } catch (error) {
        throwError(500, error)
    }
})

export const getCampaigns = asyncWrap(async (req: Request<CampaignParamsRequest>, res: Response, _next: NextFunction) => {
    try {
        const { campaignAddress } = req.params
        const programAddress = (req as CustomRequest).programAddress
        //  implement logic --megabyte

        res.status(201).json({ campaignAddress, programAddress })
    } catch (error) {
        throwError(500, error)
    }
})

export const getSubmissions = asyncWrap(async (req: Request<CampaignParamsRequest>, res: Response, _next: NextFunction) => {
    try {
        const { campaignAddress } = req.params
        const programAddress = (req as CustomRequest).programAddress
        //  implement logic --megabyte

        res.status(201).json({ campaignAddress, programAddress })
    } catch (error) {
        throwError(500, error)
    }
})

export const postSubmissions = asyncWrap(async (req: Request<CampaignParamsRequest, {}, PostCampaignSubmissionRequest>, res: Response, _next: NextFunction) => {
    try {
        const { tkbAddress, reason, isApproved } = req.body;
        if (!isApproved && !reason) throwError(401, "If application is rejected, there must be a reason passed.")
        const { campaignAddress } = req.params
        const programAddress = (req as CustomRequest).programAddress
        //  implement logic --megabyte

        res.status(201).json({ campaignAddress, programAddress, tkbAddress, reason, isApproved })
    } catch (error) {
        throwError(error.statusCode ? error.statusCode : 500, error)
    }
})

export const postCampaignSubmit = asyncWrap(async (req: Request<CampaignParamsRequest, {}, PostCampaignSubmitRequest>, res: Response, _next: NextFunction) => {
    try {
        const { tkbAddress, submissionLink } = req.body;
        const { campaignAddress } = req.params
        const programAddress = (req as CustomRequest).programAddress
        //  implement logic --megabyte

        res.status(201).json({ campaignAddress, programAddress, tkbAddress, submissionLink })
    } catch (error) {
        throwError(error.statusCode ? error.statusCode : 500, error)
    }
})