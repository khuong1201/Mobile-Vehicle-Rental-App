import { Schema, model } from 'mongoose';
import { v4 as uuidv4 } from 'uuid';

const BrandSchema = new Schema({
  brandId: {
    type: String,
    default: uuidv4,
    unique: true,
    trim: true
  },
  brandName: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  brandLogo: {
    url: { type: String, trim: true },
    publicId: { type: String, trim: true },
  }
});

export default model('Brand', BrandSchema);