const mongoose = require('mongoose');

const vehicleSchema = new mongoose.Schema({
  vehicleId: {
    type: String,
    required: true, // Bắt buộc có giá trị
    unique: true, // Ngăn trùng lặp vehicleId
    trim: true
  },
  vehicleName: {
    type: String,
    required: true,
    trim: true
  },
  brand: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Brand',
    required: true
  },
  type: {
    type: String,
    required: true, // Bắt buộc có loại xe
    trim: true,
    enum: ['Sedan', 'SUV', 'MPV', 'Pickup', 'Hatchback', 'Electric'] // Các loại xe cho phép
  },
  priceRentalMin: {
    type: Number,
    required: true
  },
  priceRentalMax: {
    type: Number,
    required: true
  }
});

// Tạo chỉ mục unique kết hợp cho vehicleName và brand
vehicleSchema.index({ vehicleName: 1, brand: 1 }, { unique: true });

module.exports = mongoose.model('Vehicle', vehicleSchema);