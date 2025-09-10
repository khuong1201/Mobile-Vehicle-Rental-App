import { Schema } from "mongoose";
import Vehicle from "./vehicle_model.js";

const BikeSchema = new Schema({});

export default Vehicle.discriminator("Bike", BikeSchema);
