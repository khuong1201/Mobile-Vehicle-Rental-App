import { Schema, model } from "mongoose";
import { v4 as uuidv4 } from "uuid";

const BookingSchema = new Schema({
  bookingId: { type: String, required: true, default: uuidv4, index: true },
  vehicleId: { type: String, ref: 'Vehicle', required: true },
  renterId: { type: String, ref: 'User', required: true },
  ownerId: { type: String, ref: 'User', required: true },
  pickupLocation: String,
  dropoffLocation: String,
  pickupDateTime: { type: Date, required: true },
  dropoffDateTime: { type: Date, required: true },
  status: {
    type: String,
    enum: [
      "pending",  
      "approved", 
      "rejected", 
      "cancelled",
      "active",   
      "completed",
      "expired"   
    ],
    default: "pending"
  },
  basePrice: Number,
  taxRate: { type: Number, default: 0 },
  taxAmount: Number,
  totalPrice: Number,
  deleted: { type: Boolean, default: false },
  isTaxDeducted: { type: Boolean, default: false },
},{ timestamps: true });

export default model('Booking', BookingSchema);