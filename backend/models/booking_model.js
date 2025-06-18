const mongoose = require("mongoose");

const BookingSchema = new mongoose.Schema({
    vehicleId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
    renterId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    ownerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    pickupLocation: String,
    dropoffLocation: String,
    pickupDate: Date,
    pickupTime: String,
    dropoffDate: Date,
    dropoffTime: String,
    status: { type: String,enum: ["pending", "rejected", "approved"], default: 'pending' },
    basePrice: Number, 
    taxRate: { type: Number, default: 0 },
    taxAmount: Number,
    totalPrice: Number,
    isTaxDeducted: { type: Boolean, default: false },
    note: String,
    createdAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model('Booking', BookingSchema);
  