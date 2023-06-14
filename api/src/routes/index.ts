import express from "express";
import programRoutes from "./program.route"
import campaignRoutes from "./campaign.route"

// import uploadImageRoutes from "./uploadImage.route";

const router = express.Router();

router.get("/", (_, res) => res.status(200).send("Healthy"));

router.use("/program", programRoutes);

router.use('/:programAddress/campaign', campaignRoutes)


export default router;
