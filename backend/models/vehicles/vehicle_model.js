const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const LocationSchema = new mongoose.Schema(
  {
    address: String,
    lat: Number,
    lng: Number,
  },
  { _id: false }
);

const VehicleSchema = new mongoose.Schema(
  {
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      trim: true,
    },
    vehicleId: {
      type: String,
      unique: true,
      default: uuidv4,
    },
    vehicleName: String,
    licensePlate: { type: String, required: true },
    brand: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Brand",
      required: true,
    },
    model: String,
    yearOfManufacture: Number,
    images: [String],
    description: String,
    location: LocationSchema,
    ownerEmail: {type: mongoose.Schema.Types.ObjectId, ref: 'User',},
    pricePerHour: Number,
    rate: { type: Number, default: 0 },
    available: { type: Boolean, default: true },
    status: { type: String, default: "pending" },
    createdAt: { type: Date, default: Date.now },
  },
  { discriminatorKey: "type", collection: "vehicles" }
);

const Vehicle = mongoose.model("Vehicle", VehicleSchema);
module.exports = Vehicle;
