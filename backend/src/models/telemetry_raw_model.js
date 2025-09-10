    import { Schema, model } from "mongoose";

    const TelemetryRawSchema = new Schema({
    deviceId: { type: String, required: true, ref: "Device" },
    ts: { type: Date, default: Date.now },
    payload: { type: Schema.Types.Mixed },
    }, { timestamps: true });

    TelemetryRawSchema.index({ deviceId: 1, ts: -1 });

    export default model("TelemetryRaw", TelemetryRawSchema);
