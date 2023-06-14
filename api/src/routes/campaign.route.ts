import express from "express"
import { postCreateCampaign } from "../controllers/campaign.controller"
import validate from "../middlewares/validateResources"
import { postCreateCampaignSchema } from "../schemas/campaign.schema"

const router = express.Router()

router.get('/', (_req, res) => {
    // TODO
    res.status(200).json(_req.params)
})

router.post('/create', validate(postCreateCampaignSchema), postCreateCampaign)

router.get('/:campaignAddress', (_req, res) => {
    // TODO
    res.status(200).json("This is program route")
})

router.get('/:campaignAddress/submissions', (_req, res) => {
    // TODO
    res.status(200).json("This is program route")
})

router.post('/:campaignAddress/submissions', (_req, res) => {
    // TODO
    res.status(200).json("This is program route")
})

router.get('/:campaignAddress/submit', (_req, res) => {
    // TODO
    res.status(200).json("This is program route")
})

export default router