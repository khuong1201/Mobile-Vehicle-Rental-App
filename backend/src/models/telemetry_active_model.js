import { Schema, model } from "mongoose";

const TelemetryActiveSchema = new Schema({
    deviceId: { type: String, required: true, ref: "Device" },
    ts: { type: Date, default: Date.now },
    location: {
        type: { type: String, enum: ["Point"], default: "Point" },
        coordinates: { type: [Number], required: true }
    },
    speedKmh: { type: Number },
    headingDeg: { type: Number },
    batteryV: { type: Number },
    deleted: { type: Boolean, default: false}
}, { timestamps: true });

TelemetryActiveSchema.index({ deviceId: 1, ts: -1 });
TelemetryActiveSchema.index({ location: "2dsphere" });

export default model("Telemetry", TelemetryActiveSchema);