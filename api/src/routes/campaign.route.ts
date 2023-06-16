import express from "express"
import { getCampaigns, getSubmissions, postCampaignSubmit, postCreateCampaign, postSubmissions } from "../controllers/campaign.controller"
import validate from "../middlewares/validateResources"
import { getCampaignsSchema, postCampaignSubmissionSchema, postCampaignSubmitSchema, postCreateCampaignSchema } from "../schemas/campaign.schema"

const router = express.Router()

router.get('/', (_req, res) => {
    // TODO
    res.status(200).json(_req.params)
})

router.post('/create', validate(postCreateCampaignSchema), postCreateCampaign)

router.get('/:campaignAddress', validate(getCampaignsSchema), getCampaigns)

router.get('/:campaignAddress/submissions', validate(getCampaignsSchema), getSubmissions)

router.post('/:campaignAddress/submissions', validate(postCampaignSubmissionSchema), postSubmissions)

router.post('/:campaignAddress/submit', validate(postCampaignSubmitSchema), postCampaignSubmit)

export default router