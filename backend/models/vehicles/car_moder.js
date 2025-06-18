const mongoose = require('mongoose');
const Vehicle = require('./vehicle.model');

const Car = Vehicle.discriminator('Car', new mongoose.Schema({
  fuelType: {
    type: String,
    required: true,
    trim: true
  },
  fuelConsumption: {
    type: Number,
    required: true
  },
  transmission: {type: String, enum: ['Automatic','Manual'],},
  numberOfSeats: { type: Number, required: true },
  rentalWithDriver: {typeof: Boolean, default: true},
}));

module.exports = Car;
