const mongoose = require('mongoose');

const WardSchema = new mongoose.Schema({
  code: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  full_name: { type: String },
  full_name_en: { type: String },
  division_type: { type: String },
  district_code: { type: String, required: true }
});
WardSchema.index({ code: 1, district_code: 1 });

const DistrictSchema = new mongoose.Schema({
  code: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  full_name: { type: String },
  full_name_en: { type: String },
  division_type: { type: String },
  province_code: { type: String, required: true },
  wards: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Ward' }]
});
DistrictSchema.index({ code: 1, province_code: 1 });

const ProvinceSchema = new mongoose.Schema({
  code: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  full_name: { type: String },
  full_name_en: { type: String },
  division_type: { type: String },
  phone_code: { type: Number },
  districts: [{ type: mongoose.Schema.Types.ObjectId, ref: 'District' }]
});
ProvinceSchema.index({ code: 1, name: 1 });

const Province = mongoose.model('Province', ProvinceSchema);
const District = mongoose.model('District', DistrictSchema);
const Ward = mongoose.model('Ward', WardSchema);

module.exports = { Province, District, Ward };