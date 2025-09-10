import { Schema, model } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';
const ReviewSchema = new Schema({
    reviewId: { type: String, unique: true, default: uuidv4 },
    vehicleId: {
        type: String,
        ref: 'Vehicle',
        required: true
    },
    renterId: {
        type: String,
        ref: 'User',
        required: true
    },
    rating: {
        type: Number,
        required: true,
        min: 1,
        max: 5
    },
    comment: {
        type: String,
        trim: true
    },
    deleted: { type: Boolean, default: false }
}, {
    timestamps: true
});

export default model('Review', ReviewSchema);