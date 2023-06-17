import { TypeOf, z } from "zod";

const walletAddress = z.string({
  required_error: "Wallet Address is Required.",
  invalid_type_error: "Must be a valid wallet address of type string",
});

export const programAddress = z.string({
  required_error: "Program Address is Required.",
  invalid_type_error: "Must be a valid program address of type string",
});

export const postCreateProgramSchema = z.object({
  body: z.object({
    walletAddress,
    name: z.string({
      required_error: "Name is Required.",
      invalid_type_error: "Must be a valid string",
    }),
    symbol: z.string({
      required_error: "Symbol is Required.",
      invalid_type_error: "Must be a valid string",
    }),
    description: z.string({
      required_error: "Description is Required.",
      invalid_type_error: "Must be a valid string",
    }),
  }),
});

export const postJoinProgramByAddressSchema = z.object({
  body: z.object({
    walletAddress,
    programAddress,
  }),
});

export const getProgramsSchema = z.object({
  query: z.object({
    walletAddress,
  }),
});

export const getProgramByAddressSchema = z.object({
  params: z.record(z.string()),
});

export type GetProgramsRequest = z.infer<typeof getProgramsSchema>["query"];

export type PostJoinProgramByAddressRequest = TypeOf<
  typeof postJoinProgramByAddressSchema
>["body"];

export type PostCreateProgramRequest = z.infer<
  typeof postCreateProgramSchema
>["body"];

export type GetProgramByAddressRequest = TypeOf<
  typeof getProgramByAddressSchema
>["params"];
