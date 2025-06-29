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
const bankAccountSchema = new mongoose.Schema(
  {
    accountNumber: { type: String, required: true },
    bankName: { type: String, required: true },
    accountHolderName: { type: String, required: true },
    // routingNumber: { type: String, required: true },
    // swiftCode: String,
  },
  { _id: false }
);
const VehicleSchema = new mongoose.Schema(
  {
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    vehicleId: {
      type:  String,
      unique: true,
      default: () => uuidv4(),
    },
    vehicleName: String,
    licensePlate: { type: String, required: true },
    brand: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Brand",
    },
    model: String,
    yearOfManufacture: String,
    images: [String], 
    imagePublicIds: [String], 
    description: String,
    location: LocationSchema,
    price: Number,
    bankAccount: bankAccountSchema,
    rate: { type: Number, default: 0 },
    available: { type: Boolean, default: true },
    status: {
      type: String,
      default: "pending",
      enum: ["pending", "rejected", "approved"],
      required: true,
    },
    createdAt: { type: Date, default: Date.now },
  },
  { discriminatorKey: "type", collection: "vehicles" }
);

const Vehicle = mongoose.model("Vehicle", VehicleSchema);
module.exports = Vehicle;