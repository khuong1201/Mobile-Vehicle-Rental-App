import { Worker } from "bullmq";
import IORedis from "ioredis";
import env from "../config/env.js";
import getRepositories from "../repositories/index.js";
import NotificationService from "../services/notification_service.js";
import NotificationValidator from "../validators/notification_validate.js";
import NotificationQueueService from "../services/notification_queue_service.js";
import connectDB from "../config/db.js";

await connectDB();

const connection = new IORedis(env.REDIS_URL, {
  maxRetriesPerRequest: null,
  enableOfflineQueue: true,
});

const worker = new Worker(
  "notifications",
  async job => {
    const { notificationId } = job.data;
    const { NotificationRepository } = await getRepositories();
    const validator = new NotificationValidator();
    const notificationQueue = new NotificationQueueService(connection);
    const service = new NotificationService(NotificationRepository, notificationQueue, validator);

    const notification = await NotificationRepository.findById(notificationId);
    if (!notification) return;

    await service.sendNotification(notification);
  },
  { connection }
);

worker.on("completed", job => console.log(`✅ Notification job ${job.id} completed`));
worker.on("failed", (job, err) => console.error(`❌ Notification job ${job.id} failed:`, err));
