import express from "express"
import { getProgramByAddress, getPrograms, postCreateProgram, postJoinProgramByAddress } from "../controllers/program.controller"
import validate from "../middlewares/validateResources"
import { getProgramByAddressSchema, getProgramsSchema, postCreateProgramSchema, postJoinProgramByAddressSchema } from "../schemas/program.schema"

const router = express.Router()

router.get('/', validate(getProgramsSchema), getPrograms)

router.post('/create', validate(postCreateProgramSchema), postCreateProgram)

router.get('/:programAddress', validate(getProgramByAddressSchema), getProgramByAddress)

router.post('/:programAddress/join', validate(postJoinProgramByAddressSchema), postJoinProgramByAddress)

export default router