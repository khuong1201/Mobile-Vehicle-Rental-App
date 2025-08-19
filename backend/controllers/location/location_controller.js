const asyncHandler = require('../../utils/async_handler');
const { Province, District, Ward } = require('../../models/location/location_in_vietnam_model');
const AppError = require('../../utils/app_error');

const getAllProvinces = asyncHandler(async (req, res, next) => {
  const provinces = await Province.find();
  return res.success("Fetched all provinces successfully", provinces, { code: "PROVINCES_FETCHED" });
});

const getDistrictsByProvince = asyncHandler(async (req, res, next) => {
  const provinceCode = parseInt(req.params.provinceCode);
  if (isNaN(provinceCode)) {
    return next(new AppError("Invalid provinceCode", 400, "INVALID_PROVINCE_CODE"));
  }
  const districts = await District.find({ province_code: provinceCode });
  return res.success("Fetched districts successfully", districts, { code: "DISTRICTS_FETCHED" });
});

const getWardsByDistrict = asyncHandler(async (req, res, next) => {
  const districtCode = parseInt(req.params.districtCode);
  if (isNaN(districtCode)) {
    return next(new AppError("Invalid districtCode", 400, "INVALID_DISTRICT_CODE"));
  }
  const wards = await Ward.find({ district_code: districtCode });
  return res.success("Fetched wards successfully", wards, { code: "WARDS_FETCHED" });
});

const postDistrictsByProvince = asyncHandler(async (req, res, next) => {
  const { provinceCode } = req.body;
  if (!provinceCode) {
    return next(new AppError("provinceCode is required", 400, "MISSING_PROVINCE_CODE"));
  }
  const districts = await District.find({ province_code: provinceCode });
  return res.success("Fetched districts successfully", districts, { code: "DISTRICTS_FETCHED" });
});

const postWardsByDistrict = asyncHandler(async (req, res, next) => {
  const { districtCode } = req.body;
  if (!districtCode) {
    return next(new AppError("districtCode is required", 400, "MISSING_DISTRICT_CODE"));
  }
  const wards = await Ward.find({ district_code: districtCode });
  return res.success("Fetched wards successfully", wards, { code: "WARDS_FETCHED" });
});

module.exports = {
  getAllProvinces,
  getDistrictsByProvince,
  getWardsByDistrict,
  postDistrictsByProvince,
  postWardsByDistrict
};
