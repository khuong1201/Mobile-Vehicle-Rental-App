import { Schema, model } from "mongoose";
import { v4 as uuidv4 } from "uuid";

const otpSchema = new Schema(
  {
    otpId: { type: String, default: () => uuidv4(), unique: true },
    userIdentifier: { type: String, required: true },
    otpHash: { type: String, required: true },
    expiresAt: { type: Date, required: true, index: { expires: 0 } }, 
  },
  { timestamps: true }
);

export default model("Otp", otpSchema);
