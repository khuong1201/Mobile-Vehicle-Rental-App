const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const LicenseSchema = new mongoose.Schema({
  licenseId: { type: String, default: () => uuidv4() },
  typeOfDriverLicense: { type: String },
  classLicense: { type: String },
  licenseNumber: { type: String },
  driverLicenseFront: String,
  driverLicenseBack: String,
  driverLicenseFrontPublicId: String,
  driverLicenseBackPublicId: String,
  status: { type: String, default: 'pending', enum: ['pending', 'approved', 'rejected'] },
});

const AddressSchema = new mongoose.Schema({
  addressId: { type: String, default: uuidv4 },
  addressType: { type: String, enum: ['home', 'work'], default: 'home' },
  address: { type: String, required: true },
  floorOrApartmentNumber: { type: String },
  contactName: { type: String, required: true },
  phoneNumber: { type: String, required: true },
});

const UserSchema = new mongoose.Schema({
  userId: { type: String, unique: true, default: uuidv4 },
  googleId: { type: String, sparse: true, unique: true },
  role: { type: String, enum: ['renter', 'owner','admin'], default: 'renter' },
  fullName: String,
  gender: String,
  email: { type: String, unique: true },
  addresses: [AddressSchema],
  avatar: String,
  phoneNumber: String,
  dateOfBirth: Date,
  IDs: String,
  passwordHash: String,
  verified: { type: Boolean, default: false }, 
  refreshToken: String,
  license: [LicenseSchema],
  points: Number,
},{ timestamps: true });

const User = mongoose.model('User', UserSchema);

module.exports = User;
