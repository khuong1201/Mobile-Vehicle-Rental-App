import { Worker } from "bullmq";
import IORedis from "ioredis";
import env from "../config/env.js";
import getRepositories from "../repositories/index.js";
import BookingService from "../services/booking_service.js";
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
  "booking-cron",
  async job => {
    const { BookingRepository, VehicleRepository, NotificationRepository } = getRepositories();
    const validator = new NotificationValidator();
    const notificationQueue = new NotificationQueueService(connection); // truyền connection Redis
    const notificationService = new NotificationService(NotificationRepository, notificationQueue, validator);
    const bookingService = new BookingService(
      BookingRepository,
      VehicleRepository,
      validator,
      notificationService
    );

    const now = new Date();
    const expiredBookings = await BookingRepository.findExpired(now);

    for (const booking of expiredBookings) {
      await bookingService.updateBookingStatus(booking.bookingId, "expired", booking.ownerId);

      await notificationService.createNotification({
        userId: booking.renterId,
        channel: "push",
        subject: "Booking expired",
        body: `Your booking for vehicle ${booking.vehicleId} has expired.`,
        meta: { bookingId: booking._id }
      });

      await notificationService.createNotification({
        userId: booking.ownerId,
        channel: "push",
        subject: "Booking expired",
        body: `The booking for your vehicle ${booking.vehicleId} has expired.`,
        meta: { bookingId: booking._id }
      });
    }

    return { processed: expiredBookings.length };
  },
  { connection }
);

worker.on("completed", job => console.log(`✅ Booking cron job ${job.id} completed`));
worker.on("failed", (job, err) => console.error(`❌ Booking cron job ${job.id} failed:`, err));