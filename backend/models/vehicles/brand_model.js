const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const BrandSchema = new mongoose.Schema({
  brandId: {
    type: String,
    default: uuidv4,
    unique: true,
    trim: true
  },
  brand: {
    type: String,
    required: true,
    unique: true,
    trim: true
  }
});

module.exports = mongoose.model('Brand', BrandSchema);
