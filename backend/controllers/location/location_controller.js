const asyncHandler = require('../../utils/async_handler');
const { Province, District, Ward } = require('../../models/location/location_in_vietnam_model');
const AppError = require('../../utils/app_error');

const getAllProvinces = asyncHandler(async (req, res, next) => {
  const provinces = await Province.find();
  res.json(provinces);
});

const getDistrictsByProvince = asyncHandler(async (req, res, next) => {
  const provinceCode = parseInt(req.params.provinceCode);
  if (isNaN(provinceCode)) {
    return next(new AppError('provinceCode không hợp lệ', 400, 'INVALID_PROVINCE_CODE'));
  }
  const districts = await District.find({ province_code: provinceCode });
  res.json(districts);
});

const getWardsByDistrict = asyncHandler(async (req, res, next) => {
  const districtCode = parseInt(req.params.districtCode);
  if (isNaN(districtCode)) {
    return next(new AppError('districtCode không hợp lệ', 400, 'INVALID_DISTRICT_CODE'));
  }
  const wards = await Ward.find({ district_code: districtCode });
  res.json(wards);
});

const postDistrictsByProvince = asyncHandler(async (req, res, next) => {
  const { provinceCode } = req.body;
  if (!provinceCode) {
    return next(new AppError('provinceCode là bắt buộc', 400, 'MISSING_PROVINCE_CODE'));
  }
  const districts = await District.find({ province_code: provinceCode });
  res.json(districts);
});

const postWardsByDistrict = asyncHandler(async (req, res, next) => {
  const { districtCode } = req.body;
  if (!districtCode) {
    return next(new AppError('districtCode là bắt buộc', 400, 'MISSING_DISTRICT_CODE'));
  }
  const wards = await Ward.find({ district_code: districtCode });
  res.json(wards);
});

module.exports = {
  getAllProvinces,
  getDistrictsByProvince,
  getWardsByDistrict,
  postDistrictsByProvince,
  postWardsByDistrict
};
