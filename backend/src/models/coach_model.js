import { Schema } from "mongoose";
import Vehicle from "./vehicle_model.js";

const CoachSchema = new Schema({
  numberOfSeats: { type: Number, required: true },
  transmission: { type: String, enum: ["Automatic", "Manual"] },
  fuelType: { type: String, required: true, trim: true },
});

export default Vehicle.discriminator("Coach", CoachSchema);
