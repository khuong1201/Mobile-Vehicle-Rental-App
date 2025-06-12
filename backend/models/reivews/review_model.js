const mongoose = require('mongoose');

const ReviewSchema = new mongoose.Schema({
  vehicleId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Vehicle',
    required: true
  },
  renterId: {
    type: mongoose.Schema.Types.ObjectId,
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
  reviewCount: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true 
});

module.exports = mongoose.model('Review', ReviewSchema);
