const mongoose = require("mongoose");

const PaymentSchema = new mongoose.Schema({
  paymentId: { type: String, required: true, unique: true }, 
  bookingId: { type: mongoose.Schema.Types.ObjectId, ref: 'Booking', required: true },              
  renterId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  amount: { type: Number, required: true },
  provider: { type: String, enum: ["MoMo", "ZaloPay", "VNPay", "Viettin"], default: "MoMo" },
  status: { type: String, enum: ["pending", "success", "failed"], default: "pending" },
  payUrl: String,          
  responseData: Object,    
  createdAt: { type: Date, default: Date.now },
  updatedAt: Date,
});

module.exports = mongoose.model("Payment", PaymentSchema);
