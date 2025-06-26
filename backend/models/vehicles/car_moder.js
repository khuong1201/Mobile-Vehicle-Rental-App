const mongoose = require('mongoose');
const Vehicle = require('./vehicle.model');

const Car = Vehicle.discriminator('Car', new mongoose.Schema({
  fuelType: {
    type: String,
    required: true,
    trim: true
  },
  transmission: {type: String, enum: ['Automatic','Manual'],},
  numberOfSeats: { type: Number, required: true },
}));

module.exports = Car;
