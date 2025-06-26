const Vehicle = require('./vehicle_model');
const mongoose = require('mongoose');

const BikeSchema = new mongoose.Schema({});

module.exports = Vehicle.discriminator('Bike', BikeSchema);
