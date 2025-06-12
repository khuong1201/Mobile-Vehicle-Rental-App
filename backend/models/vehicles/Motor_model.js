const Vehicle = require('./base.model');
const mongoose = require('mongoose');

const MotorSchema = new mongoose.Schema({
    fuelType: {
        type: String,
        required: true,
        trim: true
    },
    fuelConsumption: {
        type: Number,
        required: true
    },
});

module.exports = Vehicle.discriminator('Motor', MotorSchema);
