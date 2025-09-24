import { Queue } from "bullmq";
import IORedis from "ioredis";
import env from "../config/env.js";

const connection = new IORedis(env.REDIS_URL);

export const bookingQueue = new Queue("booking-cron", { connection });
