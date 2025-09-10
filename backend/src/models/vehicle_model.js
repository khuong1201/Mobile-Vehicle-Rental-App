import mongoose from "mongoose";
import { v4 as uuidv4 } from "uuid";

const LocationSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      enum: ["Point"],
      default: "Point",
    },
    coordinates: {
      type: [Number],
      required: true,
    },
    address: String,
  },
  { _id: false }
);

const BankAccountSchema = new mongoose.Schema(
  {
    accountNumber: { type: String, required: true },
    bankName: { type: String, required: true },
    accountHolderName: { type: String, required: true },
  },
  { _id: false }
);

const VehicleSchema = new mongoose.Schema(
  {
    vehicleId: { type: String, default: uuidv4, unique: true },
    ownerId: {
      type: String,
      ref: "User",
      required: true,
    },
    vehicleName: { type: String },
    licensePlate: { type: String, required: true },
    brandId: {
      type: String,
      ref: "Brand",
      required: true,
    },
    model: { type: String },
    yearOfManufacture: { type: Number }, 
    images: [{ type: String }],
    imagePublicIds: [{ type: String }],
    description: { type: String },
    location: LocationSchema,
    price: { type: Number },
    bankAccount: BankAccountSchema,
    averageRating: { type: Number, default: 0 },
    reviewCount: { type: Number, default: 0 },
    available: { type: Boolean, default: true },
    deleted: { type: Boolean, default: false },
    status: {
      type: String,
      enum: ["pending", "rejected", "approved"],
      default: "pending",
      required: true,
    },
    createdAt: { type: Date, default: Date.now },
  },
  { discriminatorKey: "type", collection: "vehicles" }
);

const Vehicle = mongoose.model("Vehicle", VehicleSchema);

export default Vehicle;