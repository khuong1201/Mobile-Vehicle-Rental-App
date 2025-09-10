import { Schema, model } from "mongoose";
import { v4 as uuidv4 } from "uuid";

const BannerSchema = new Schema({
  bannerId: { type: String, default: uuidv4, unique: true },
  bannerName: { type: String, unique: true, trim: true },
  bannerImage: {
    url: { type: String, trim: true },
    publicId: { type: String, trim: true },
  },
  deleted: { type: Boolean, default: false },
}, { timestamps: true });

export default model("Banner", BannerSchema);
