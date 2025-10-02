import AppError from "../utils/app_error.js";

export default class NotificationValidator {
  validateCreate(data) {
    if (!data?.userId) throw new AppError("User ID is required");
    if (!data?.channel) throw new AppError("Notification channel is required");
    if (
      (data.channel === "email" || data.channel === "sms") &&
      !data?.destination
    ) {
      throw new AppError("Destination is required");
    }
    if (!data?.subject) throw new AppError("Subject is required");
    if (!data?.body) throw new AppError("Body is required");
  }

  validateSend(data) {
    if (!data?.notificationId)
      throw new AppError("Notification ID is required");
    if (!data?.channel) throw new AppError("Notification channel is required");
  }

  validateMarkAsSent({ notificationId, providerMessageId }) {
    if (!notificationId) throw new AppError("Notification ID is required");
    if (!providerMessageId)
      throw new AppError("Provider message ID is required");
  }

  validateMarkAsFailed({ notificationId, errorMessage }) {
    if (!notificationId) throw new AppError("Notification ID is required");
    if (!errorMessage) throw new AppError("Error message is required");
  }
}
