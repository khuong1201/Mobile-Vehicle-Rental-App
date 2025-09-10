import { Schema } from "mongoose";
import Vehicle from "./vehicle_model.js";

const CarSchema = new Schema({
  fuelType: { type: String, required: true, trim: true },
  transmission: { type: String, enum: ["Automatic", "Manual"], default: "Manual" },
  numberOfSeats: { type: Number, required: true },
});

export default Vehicle.discriminator("Car", CarSchema);
