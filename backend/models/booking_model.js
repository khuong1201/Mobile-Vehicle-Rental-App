const BookingSchema = new mongoose.Schema({
    vehicleId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
    renterId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    startTime: Date,
    endTime: Date,
    status: String,
    totalPrice: Number,
    note: String,
    createdAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model('Booking', BookingSchema);
  