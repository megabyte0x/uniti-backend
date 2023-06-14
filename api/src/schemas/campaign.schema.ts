import { z } from "zod";

export const postCreateCampaignSchema = z.object({
    body: z.object({
        name: z.string({
            required_error: "Name is Required.",
            invalid_type_error: "Must be a valid string"
        }),
        description: z.string({
            required_error: "Description is Required.",
            invalid_type_error: "Must be a valid string"
        }),
        amount: z.string({
            required_error: "Amount is Required.",
            invalid_type_error: "Must be a valid string of numbers"
        }).regex(/^[0-9]+$/, {
            message: "Amount should be string of numbers"
        })
    }),
    params: z.record(z.string())
})


export type PostCreateCampaignRequest = z.infer<typeof postCreateCampaignSchema>["body"]

export type ParamsRequest = z.infer<typeof postCreateCampaignSchema>["params"]