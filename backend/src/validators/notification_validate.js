import AppError from "../utils/app_error.js";

export default class NotificationValidator {
  validateCreate(data) {
    if (!data.userId) throw new AppError("User ID is required");
    if (!data.channel) throw new AppError("Notification channel is required");
    if (!data.destination) throw new AppError("Destination is required");
    if (!data.subject) throw new AppError("Subject is required");
    if (!data.body) throw new AppError("Body is required");
  }

  validateSend(data) {
    if (!data._id) throw new AppError("Notification ID is required");
    if (!data.channel) throw new AppError("Notification channel is required");
  }

  validateMarkAsSent({ id, providerMessageId }) {
    if (!id) throw new AppError("Notification ID is required");
    if (!providerMessageId) throw new AppError("Provider message ID is required");
  }

  validateMarkAsFailed({ id, errorMessage }) {
    if (!id) throw new AppError("Notification ID is required");
    if (!errorMessage) throw new AppError("Error message is required");
  }
}
