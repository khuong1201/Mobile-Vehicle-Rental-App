const Vehicle = require('./vehicle_model');
const mongoose = require('mongoose');

const MotorSchema = new mongoose.Schema({
    fuelType: {
        type: String,
        required: true,
        trim: true
    },
});

module.exports = Vehicle.discriminator('Motor', MotorSchema);
