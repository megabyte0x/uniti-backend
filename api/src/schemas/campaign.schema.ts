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
    params: z.record(z.string({
        invalid_type_error: "Params should be of type string and address",
        required_error: "Program address is required"
    }))
})

export const getCampaignsSchema = z.object({
    params: z.record(z.string({
        invalid_type_error: "Params should be of type string and address",
        required_error: "Program address or Campaign Address is required"
    }))
})

export const postCampaignSubmissionSchema = z.object({
    body: z.object({
        tkbAddress: z.array(z.string({
            invalid_type_error: "Must be of type array of strings",
            required_error: "tkbAddress are required"
        }), {
            invalid_type_error: "Must be of type array of strings",
            required_error: "tkbAddress are required"
        }).min(1),
        reason: z.array(z.string({
            invalid_type_error: "Must be of type Array of strings."
        })).optional(),
        isApproved: z.boolean({
            invalid_type_error: "Must be of type Boolean.",
            required_error: "Approval or Rejection value is required."
        })
    }),
    params: z.record(z.string({
        invalid_type_error: "Params should be of type string and address",
        required_error: "Program address or Campaign Address is required"
    }))
})

export const postCampaignSubmitSchema = z.object({
    body: z.object({
        tkbAddress: z.string({
            invalid_type_error: "Must be of type string",
            required_error: "tkbAddress is required"
        }),
        submissionLink: z.string({
            invalid_type_error: "Must be of type string and a url.",
            required_error: "Submission Link is required"
        }).url(),
    }),
    params: z.record(z.string({
        invalid_type_error: "Params should be of type string and address",
        required_error: "Program address or Campaign Address is required"
    }))
})

export type PostCreateCampaignRequest = z.infer<typeof postCreateCampaignSchema>["body"]

export type CampaignParamsRequest = z.infer<typeof postCreateCampaignSchema>["params"]

export type PostCampaignSubmissionRequest = z.infer<typeof postCampaignSubmissionSchema>["body"]

export type PostCampaignSubmitRequest = z.infer<typeof postCampaignSubmitSchema>["body"]
