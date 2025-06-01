const LocationSchema = new mongoose.Schema({
    address: String,
    lat: Number,
    lng: Number
  }, { _id: false });
  
  const VehicleSchema = new mongoose.Schema({
    ownerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
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
  