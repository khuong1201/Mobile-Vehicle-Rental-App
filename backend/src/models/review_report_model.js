import { Schema, model } from "mongoose";
import { v4 as uuidv4 } from 'uuid';

const ReviewReportSchema = new Schema({
    reviewReportId: { type: String, unique: true, default: uuidv4 },
    reviewId: {
        type: String,
        ref: "Review",
        required: true,
    },
    vehicleId: {
        type: String,
        ref: "Vehicle",
        required: true,
    },
    reporterId: {
        type: String,
        ref: "User",
        required: true,
    },
    reason: {
        type: String,
        required: true,
        trim: true,
    },
    status: {
        type: String,
        enum: ["pending", "reviewed", "rejected"],
        default: "pending",
    },
    deleted: { type: Boolean, default: false },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

export default model("ReviewReport", ReviewReportSchema);