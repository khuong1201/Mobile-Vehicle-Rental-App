const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const LicenseSchema = new mongoose.Schema({
    typeOfDriverLicense: { type: String, required: true },
    classLicense: { type: String, required: true },
    licenseNumber: { type: String, required: true },
    driverLicenseFront: { type: String, required: true },
    driverLicenseBack: { type: String, required: true },
    approved: Boolean
});
const AddressSchema = new mongoose.Schema({
    addressType: { type: String, enum: ['home', 'work'], default: 'home' },
    address: { type: String, required: true },
    floorOrApartmentNumber: { type: String, required: true },
    contactName: { type: String, required: true },
    phoneNumber: { type: String, required: true },
});
const UserSchema = new mongoose.Schema({
    userId: { type: String, unique: true, default: uuidv4 },
    googleId: { type: String, sparse: true, unique: true },
    role: { type: String, enum: ['renter', 'owner'], default: 'renter' },
    fullName: String,
    gender: String,
    email: { type: String, unique: true },
    addresses: [AddressSchema],
    phoneNumber: String,
    dateOfBirth: Date,
    IDs: String,
    passwordHash: String,
    verified: Boolean,
    otp: String,
    otpExpires: Date,
    refreshToken: String,
    license: [LicenseSchema],
    points: Number,
},{ timestamps: true });

UserSchema.index(
    { otpExpires: 1 },
    {
        expireAfterSeconds: 0,
        partialFilterExpression: {
            verified: false
        }
    }
);

const User = mongoose.model('User', UserSchema);

User.syncIndexes().then(() => {
    console.log('Indexes synced for User model');
}).catch(err => {
    console.error('Error syncing indexes:', err);
});

module.exports = User;