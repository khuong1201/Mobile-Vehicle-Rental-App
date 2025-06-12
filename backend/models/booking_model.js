const BookingSchema = new mongoose.Schema({
    vehicleId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
    renterId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    onwerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    pickupLocation: String,
    dropoffLocation: String,
    pickupDate: Date,
    pickupTime: String,
    dropoffDate: Date,
    dropoffTime: String,
    status: String,
    totalPrice: Number,
    note: String,
    createdAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model('Booking', BookingSchema);
  