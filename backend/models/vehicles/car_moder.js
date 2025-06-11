const mongoose = require('mongoose');
const Vehicle = require('./vehicle.model');

const Car = Vehicle.discriminator('Car', new mongoose.Schema({
  fuelType: String,
  hasAirConditioner: Boolean
}));

module.exports = Car;
