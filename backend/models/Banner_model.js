const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const BannerSchema = new mongoose.Schema({
  bannerId: { type: String, defaut: uuidv4 },
  bannerName: { type: String, unique: true, trim: true },
  bannerUrl: { type: String },
});
