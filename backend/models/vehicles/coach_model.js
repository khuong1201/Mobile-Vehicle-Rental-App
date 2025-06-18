const Vehicle = require('./base.model');
const mongoose = require('mongoose');

const CoachSchema = new mongoose.Schema({
  numberOfSeats: { type: Number, required: true },
  transmission: {type: String, enum: ['Automatic','Manual'],},
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
