import { Schema, model } from "mongoose";
import { v4 as uuidv4 } from "uuid";

const DeviceSchema = new Schema({
    deviceId: { type: String, default: uuidv4, unique: true },
    imei: { type: String,},
    simNumber: { type: String },
    vehicleId: { type: String, ref: "Vehicle" },
    installedAt: { type: Date, default: Date.now() },
    status: { type: String, enum: ["active", "inactive"], default: "inactive" },
    deviceToken: { type: String, unique: true },
    deleted: { type: Boolean, default: false}
}, { timestamps: true });

export default model("Device", DeviceSchema);