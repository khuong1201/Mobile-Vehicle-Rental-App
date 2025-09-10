import asyncHandler from "../middlewares/async_handler.js";

export default class NotificationController {
  constructor(notificationService) {
    this.service = notificationService;

    this.createNotification = asyncHandler(this.createNotification.bind(this));
    this.sendNotification = asyncHandler(this.sendNotification.bind(this));
    this.markAsSent = asyncHandler(this.markAsSent.bind(this));
    this.markAsFailed = asyncHandler(this.markAsFailed.bind(this));
    this.markAsRead = asyncHandler(this.markAsRead.bind(this));
  }

  async createNotification(req, res) {
    const data = await this.service.createNotification(req.body);
    res.json({ status: "success", data });
  }

  async sendNotification(req, res) {
    const { notificationId } = req.params;
    const notification = await this.service.notificationRepo.findById(notificationId);
    if (!notification) throw new Error("Notification not found");
    const data = await this.service.sendNotification(notification);
    res.json({ status: "success", data });
  }

  async markAsSent(req, res) {
    const { notificationId } = req.params;
    const { providerMessageId } = req.body;
    const data = await this.service.markAsSent(notificationId, providerMessageId);
    res.json({ status: "success", data });
  }

  async markAsFailed(req, res) {
    const { notificationId } = req.params;
    const { errorMessage } = req.body;
    const data = await this.service.markAsFailed(notificationId, errorMessage);
    res.json({ status: "success", data });
  }

  async markAsRead(req, res) {
    const { notificationId } = req.params;
    const data = await this.service.markAsRead(notificationId);
    res.json({ status: "success", data });
  }
}