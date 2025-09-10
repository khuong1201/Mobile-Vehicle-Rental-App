import { Schema, model } from "mongoose";
import { v4 as uuidv4 } from "uuid";

const notificationSchema = new Schema(
  {
    notificationId: { type: String, default: uuidv4, unique: true },
    userId: { type: String, required: true, index: true, ref: "User" },
    channel: { type: String, enum: ["sms", "email", "push"], required: true },
    destination: { type: String, required: true },
    subject: { type: String },
    body: { type: String, required: true },
    status: { type: String, enum: ["pending", "sent", "failed"], default: "pending" },
    errorMessage: { type: String },
    providerMessageId: { type: String },
    pushPayload: { type: Schema.Types.Mixed },
    read: { type: Boolean, default: false },
    deleted: { type: Boolean, default: false },
    meta: { type: Schema.Types.Mixed },
  },
  { timestamps: true }
);

notificationSchema.index({ createdAt: -1 });

export default model("Notification", notificationSchema);