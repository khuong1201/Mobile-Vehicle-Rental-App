import express from 'express';
import cors from 'cors';
import env from './config/env.js';
import connectDB from './config/db.js';
import routes from './routes/index.js';
import { scheduleBookingExpirationJob } from "./jobs/booking_jobs.js";
const app = express();

app.use(cors({ origin: env.CORS_ORIGIN }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

connectDB();
scheduleBookingExpirationJob();
app.use('/api', routes);

const { errorHandler } = await import('./middlewares/error_middlerware.js');
app.use(errorHandler);

export default app;