import express, { Application, Request, Response } from 'express';
import * as dotenv from 'dotenv';
import cors from 'cors';
import router from './routes/index';
import cookieParser from 'cookie-parser';
import { ErrorHandler } from './helpers/errorHandler.helper';

dotenv.config();
const app: Application = express();
const PORT = process.env.PORT || 5001;
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser())
// ============================================================
// Reconfig origin later
// ============================================================
app.use(cors({ origin: 'http://localhost:3000', credentials: true }));

// app.use((req, res, next) => {
//     res.header('Access-Control-Allow-Origin', '*');
//     next();
// });

app.use('/api/v1', router)


app.get('/', (_: Request, res: Response) => {
    res.send('Hello World!');
});

app.use(ErrorHandler);

app.listen(PORT, () => {
    console.log(`App listening at: ${PORT}`);
});