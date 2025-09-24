import admin from "firebase-admin";
import env from "../config/env.js";
import getRepositories from "../repositories/index.js";

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(env.FIREBASE_SERVICE_ACCOUNT),
  });
}

export default class PushProvider {
  constructor() {
    this.messaging = admin.messaging();
  }

  async send(userId, payload) {
    const { UserRepository} = getRepositories();
    const user = await UserRepository.findById(userId);
    if (!user) throw new Error("User not found");
    if (!user.deviceTokens || user.deviceTokens.length === 0)
      throw new Error("User has no registered device tokens");

    const message = {
      notification: { title: payload.title, body: payload.body },
      data: payload.data || {},
      tokens:  user.deviceTokens.map(d => d.token),
    };

    const response = await this.messaging.sendMulticast(message);
    const successful = response.responses.filter(r => r.success).map(r => r.messageId);
    if (successful.length === 0) throw new Error("Failed to send push notification");

    return successful.join(",");
  }
}