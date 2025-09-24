import { bookingQueue } from "../queues/booking_queue.js";

export const scheduleBookingExpirationJob = async () => {
  await bookingQueue.add(
    "check-expired-bookings",
    {},
    {
      repeat: { cron: "* * * * *" },
      removeOnComplete: true,
      removeOnFail: true,
    }
  );

  console.log("📅 Booking expiration repeatable job scheduled");
};
