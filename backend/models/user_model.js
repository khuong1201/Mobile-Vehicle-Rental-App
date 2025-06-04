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