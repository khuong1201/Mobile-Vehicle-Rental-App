const Vehicle = require('./base.model');
const mongoose = require('mongoose');

const MotorSchema = new mongoose.Schema({});

module.exports = Vehicle.discriminator('Motor', MotorSchema);
