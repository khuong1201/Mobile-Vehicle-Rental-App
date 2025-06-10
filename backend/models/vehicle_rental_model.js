const LocationSchema = new mongoose.Schema({
  address: String,
  lat: Number,
  lng: Number
}, { _id: false });

const VehicleSchema = new mongoose.Schema({
  ownerId: { type: mongoose.Schema.Types.userID, ref: 'User', unique: true, required: true, trim: true },
  vehicleId: { type: mongoose.Schema.Types.vehicleId, ref: 'Vehicle', unique: true, required: true, trim: true },
  name: String,
  type: String,
  brand: String,
  seats: Number,
  gearbox: String,
  features: [String],
  images: [String],
  description: String,
  pricePerHour: Number,
  available: Boolean,
  location: LocationSchema,
  status: String,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Vehicle', VehicleSchema);
