const Vehicle = require('./base.model');
const mongoose = require('mongoose');

const CoachSchema = new mongoose.Schema({
  numberOfSeats: { type: Number, required: true },
  rentalWithDriver: { type: Boolean, default: false },
  rentalWithoutDriver: { type: Boolean, default: true },
  fuelType: {
    type: String,
    required: true,
    trim: true,
  },
  fuelConsumption: {
    type: Number,
    required: true,
  },
});

module.exports = Vehicle.discriminator('Coach', CoachSchema);
