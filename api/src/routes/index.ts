import express from "express";
import nftRoutes from "./nft.route"

// import uploadImageRoutes from "./uploadImage.route";

const router = express.Router();

router.get("/", (_, res) => res.status(200).send("Healthy"));

router.use("/nft", nftRoutes);


export default router;
