import { notificationQueue } from "../queues/notification_queue.js";

export default class NotificationQueueService {
  async enqueueNotification(notificationId) {
    return notificationQueue.add(
      "send_notification",
      { notificationId },
      {
        attempts: 3,
        backoff: 5000,
        removeOnComplete: true,
        removeOnFail: false
      }
    );
  }
}
