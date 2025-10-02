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
    const { UserRepository } = await getRepositories();
    const user = await UserRepository.findById(userId);

    if (!user) throw new Error("User not found");
    if (!user.deviceTokens || user.deviceTokens.length === 0)
      throw new Error("User has no registered device tokens");

    // Lọc token active
    const activeTokens = user.deviceTokens.filter(t => !t.deleted);
    if (activeTokens.length === 0)
      throw new Error("User has no active device tokens");

    console.log("Sending push to userId:", userId);
    console.log("Active device tokens:", activeTokens.map(d => d.token));
    console.log("Payload:", payload);

    try {
      const results = await Promise.all(
        activeTokens.map(async (t) => {
          const token = t.token;
          try {
            const msgId = await this.messaging.send({
              notification: { title: payload.title, body: payload.body },
              data: payload.data || {},
              token,
            });
            console.log(`✅ Sent to token ${token}, messageId: ${msgId}`);
            return { token, success: true, msgId };
          } catch (err) {
            console.error(`❌ Failed token ${token}`, err);

            // Soft delete token thất bại
            t.deleted = true;
            try {
              await UserRepository.update(user.id, { deviceTokens: user.deviceTokens });
              console.log(`🗑 Soft deleted token ${token} for user ${userId}`);
            } catch (updateErr) {
              console.error("Failed to soft delete token:", updateErr);
            }

            return { token, success: false, error: err };
          }
        })
      );

      const successful = results.filter(r => r.success).map(r => r.msgId);

      if (successful.length === 0)
        throw new Error("Failed to send push notification to any device");

      console.log("Successfully sent messages:", successful);
      return successful.join(",");
    } catch (err) {
      console.error("Error sending push:", err);
      throw err;
    }
  }
}
