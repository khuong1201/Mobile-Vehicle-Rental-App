import { Worker } from "bullmq";
import IORedis from "ioredis";
import env from "../config/env.js";
import getRepositories from "../repositories/index.js";
import NotificationService from "../services/notification_service.js";

const connection = new IORedis(env.REDIS_URL);

const worker = new Worker(
  "notifications",
  async job => {
    const { notificationId } = job.data;
    const { NotificationRepository, Validator } = getRepositories();

    const service = new NotificationService(NotificationRepository, Validator);

    const notification = await NotificationRepository.findById(notificationId);
    if (!notification) return;

    await service.sendNotification(notification);
  },
  { connection }
);

worker.on("completed", job => {
  console.log(`✅ Job ${job.id} completed`);
});

worker.on("failed", (job, err) => {
  console.error(`❌ Job ${job.id} failed:`, err);
});