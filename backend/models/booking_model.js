const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const BookingSchema = new mongoose.Schema({
  bookingId: { type: String, required: true, default: uuidv4, index: true },
  vehicleId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
  renterId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  ownerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  pickupLocation: String,
  dropoffLocation: String,
  pickupDate: Date,
  pickupTime: String,
  dropoffDate: Date,
  dropoffTime: String,
  status: { type: String, enum: ["pending", "rejected", "approved"], default: 'pending' },
  basePrice: Number,
  taxRate: { type: Number, default: 0 },
  taxAmount: Number,
  totalPrice: Number,
  totalRentalDays: { type: Number, required: true },
  isTaxDeducted: { type: Boolean, default: false },
},{ timestamps: true });

// Ẩn _id và __v khi trả JSON
BookingSchema.methods.toJSON = function () {
  const obj = this.toObject();
  delete obj._id;
  delete obj.__v;
  return obj;
};

module.exports = mongoose.model('Booking', BookingSchema);
