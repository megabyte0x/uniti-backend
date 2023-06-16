import express, { Request } from "express";
import programRoutes from "./program.route"
import campaignRoutes from "./campaign.route"

export interface CustomRequest extends Request {
    programAddress: string;
}

const router = express.Router();

router.param('programAddress', (_req, _res, next, value) => {
    (_req as CustomRequest).programAddress = value
    next()
})

router.get("/", (_, res) => res.status(200).send("Healthy"));

router.use("/program", programRoutes);

router.use('/:programAddress/campaign', campaignRoutes)


export default router;
