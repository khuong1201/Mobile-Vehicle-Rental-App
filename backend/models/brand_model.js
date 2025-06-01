const mongoose = require('mongoose');

const brandSchema = new mongoose.Schema({
  brandId: {
    type: String,
    required: true, // Bắt buộc có giá trị
    unique: true, // Ngăn trùng lặp brandId
    trim: true
  },
  brand: {
    type: String,
    required: true,
    unique: true, // Ngăn trùng lặp tên hãng
    trim: true // Xóa khoảng trắng thừa
  }
});

module.exports = mongoose.model('Brand', brandSchema);