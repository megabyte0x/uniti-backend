import { NextFunction, Request, Response } from "express";
import { AnyZodObject } from "zod";
import { throwError } from "../helpers/errorHandler.helper";

const validate =
    (schema: AnyZodObject) =>
        (req: Request, _res: Response, next: NextFunction) => {
            try {
                schema.parse({
                    body: req.body,
                    query: req.query,
                    params: req.params,
                });
                next();
            } catch (e: any) {
                console.error(e.issues);
                throwError(400, e.issues[0].message);
            }
        };

export default validate;