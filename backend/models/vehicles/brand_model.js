const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const BrandSchema = new mongoose.Schema({
  brandId: {
    type: String,
    default: uuidv4,
    unique: true,
    trim: true
  },
  brandName: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  brandLogo: {
    type: String,
    trim: true,
  }
});

module.exports = mongoose.model('Brand', BrandSchema);
