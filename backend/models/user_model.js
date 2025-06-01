const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid'); 

const LicenseSchema = new mongoose.Schema({
    number: String,
    imageUrl: String,
    approved: Boolean
}, { _id: false });

const UserSchema = new mongoose.Schema({
    userId: { type: String, unique: true, default: uuidv4 }, 
    googleId: { type: String, sparse: true, unique: true },
    role: { type: String, enum: ['renter', 'owner'], default: 'renter' },
    fullName: String,
    email: { type: String, unique: true },
    passwordHash: String,
    verified: Boolean,
    otp: String,
    otpExpires: Date,
    refreshToken: String,
    license: LicenseSchema,
    points: Number,
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', UserSchema);