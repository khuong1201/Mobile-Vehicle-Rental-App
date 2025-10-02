import { Schema, model } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

const LicenseSchema = new Schema({
    licenseId: { type: String, default: () => uuidv4() },
    typeOfDriverLicense: { type: String },
    classLicense: { type: String },
    licenseNumber: { type: String },
    driverLicenseFront: String,
    driverLicenseBack: String,
    driverLicenseFrontPublicId: String,
    driverLicenseBackPublicId: String,
    status: { type: String, default: 'pending', enum: ['pending', 'approved', 'rejected'] },
    deleted: { type: Boolean, default: false },
});

const AddressSchema = new Schema({
    addressId: { type: String, default: uuidv4 },
    addressType: { type: String, enum: ['home', 'work'], default: 'home' },
    address: { type: String, required: true },
    floorOrApartmentNumber: { type: String },
    contactName: { type: String, required: true },
    phoneNumber: { type: String, required: true },
    deleted: { type: Boolean, default: false },
});
const DeviceTokenSchema = new Schema({
    token: { type: String, required: true, index: true },
    platform: { type: String, enum: ["ios", "android", "web"], required: true },
    deviceId: { type: String },
    deleted: { type: Boolean, default: false },
    lastUsedAt: { type: Date, default: Date.now }
});

const UserSchema = new Schema({
    userId: { type: String, unique: true, default: uuidv4 },
    googleId: { type: String, sparse: true, unique: true },
    role: { type: String, enum: ['renter', 'owner', 'admin'], default: 'renter' },
    fullName: String,
    gender: String,
    email: { type: String, unique: true },
    addresses: [AddressSchema],
    avatar: String,
    phoneNumber: String,
    dateOfBirth: Date,  
    nationalIdNumber: [String],
    passwordHash: String,
    verified: { type: Boolean, default: false },
    refreshToken: String,
    license: [LicenseSchema],
    points: Number,
    deleted: { type: Boolean, default: false },
    deviceTokens: [DeviceTokenSchema], 
}, { timestamps: true });

const User = model('User', UserSchema);

export default User;