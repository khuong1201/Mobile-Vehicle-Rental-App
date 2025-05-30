const PaymentSchema = new mongoose.Schema({
    bookingId: { type: mongoose.Schema.Types.ObjectId, ref: 'Booking', required: true },
    amount: Number,
    method: String,
    status: String,
    transactionId: String,
    invoiceUrl: String,
    createdAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model('Payment', PaymentSchema);
  