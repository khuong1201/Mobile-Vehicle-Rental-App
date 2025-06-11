const Vehicle = require('./base.model');
const mongoose = require('mongoose');

const CoachSchema = new mongoose.Schema({
  numberOfSeats: Number
});

module.exports = Vehicle.discriminator('Coach', CoachSchema);
