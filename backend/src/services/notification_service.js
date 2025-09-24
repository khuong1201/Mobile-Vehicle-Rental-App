import AppError from "../utils/app_error.js";
import EmailProvider from "../config/email.js";
import PushProvider from "../config/push.js";

export default class NotificationService {
  constructor(notificationRepo, queueService, validator) {
    this.notificationRepo = notificationRepo;
    this.validator = validator;
    this.queueService = queueService;
    this.emailProvider = new EmailProvider();
    this.pushProvider = new PushProvider();
  }

  async createNotification(data) {
    this.validator.validateCreate(data);
    const notification = await this.notificationRepo.create({ ...data, status: "pending" });

    await this.queueService.add("send", { notificationId: notification._id });
  
    return notification;
  }

  async sendNotification(notification) {
    this.validator.validateSend(notification);
    try {
      let providerMessageId;

      switch (notification.channel) {
        case "email":
          providerMessageId = await this.emailProvider.send(
            notification.destination,
            notification.subject,
            notification.body
          );
          break;
        case "push":
          providerMessageId = await this.pushProvider.send(notification.userId, {
            title: notification.subject,
            body: notification.body,
            data: notification.meta
          });
          break;
        default:
          throw new AppError(`Unsupported channel: ${notification.channel}`, 400);
      }

      return this.markAsSent(notification.notificationId, providerMessageId);
    } catch (err) {
      return this.markAsFailed(notification.notificationId, err.message);
    }
  }

  async markAsSent(notificationId, providerMessageId) {
    return this.notificationRepo.markAsSent(notificationId, providerMessageId);
  }

  async markAsFailed(notificationId, errorMessage) {
    return this.notificationRepo.markAsFailed(notificationId, errorMessage);
  }
}