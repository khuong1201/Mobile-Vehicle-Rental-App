import INotificationRepository from "../interfaces/i_notification_repo.js";
import Notification from "../../models/notification_model.js";

export default class NotificationRepositoryMongo extends INotificationRepository {
  constructor() {
    super();
    this.model = Notification;
  }

  async create(data) {
    return this.model.create(data);
  }

  async findById(notificationId) {
    return this.model.findOne({ notificationId, deleted: false }).lean();
  }

  async find(filter = {}, options = {}) {
    const query = this.model.find({ ...filter, deleted: false });

    if (options.skip) query.skip(options.skip);
    if (options.limit) query.limit(options.limit);
    if (options.sort) query.sort(options.sort);

    return query.lean();
  }

  async update(notificationId, data) {
    return this.model.findOneAndUpdate(
      { notificationId },
      data,
      { new: true }
    ).lean();
  }

  async delete(notificationId) {
    return this.update(notificationId, { deleted: true });
  }

  async markAsSent(notificationId, providerMessageId) {
    return this.update(notificationId, { status: "sent", providerMessageId });
  }

  async markAsFailed(notificationId, errorMessage) {
    return this.update(notificationId, { status: "failed", errorMessage });
  }

  async markAsRead(notificationId) {
    return this.update(notificationId, { read: true });
  }
}