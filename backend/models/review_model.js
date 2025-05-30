const ReviewSchema = new mongoose.Schema({
    vehicleId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle', required: true },
    renterId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    rating: Number,
    comment: String,
    createdAt: { type: Date, default: Date.now }
  });
  
  module.exports = mongoose.model('Review', ReviewSchema);
  