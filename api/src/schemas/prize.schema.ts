import { z } from "zod";
import { userSchema } from "./user.schema";



const prize = {
    amount: z.number({
        required_error: "Amount is Required",
        invalid_type_error: "Amount must be positive"
    }).gte(0),
    distriutedAmong: z.number({
        required_error: "Please provide the number of people among which the prize must be distributed.",
        invalid_type_error: "Atleast there should be 1 person to claim the prize"
    }).gte(1)
}

export const prizeSchema = z.object(prize)


export const addAwardRequestSchema = z.object({
    body: z.object({
        ...prize,
        users: z.array(userSchema)
    })
})

export type AddAwardRequest = z.infer<typeof addAwardRequestSchema>