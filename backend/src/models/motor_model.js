import { Schema } from "mongoose";
import Vehicle from "./vehicle_model.js";

const MotorSchema = new Schema({
  fuelType: { type: String, required: true, trim: true },
});

export default Vehicle.discriminator("Motor", MotorSchema);
