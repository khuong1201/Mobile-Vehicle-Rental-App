const { Province, District, Ward } = require('../../models/location/location_in_vietnam_model');
const AppError = require('../../utils/app_error');

const getAllProvinces = async (req, res, next) => {
  try {
    const provinces = await Province.find();
    res.json(provinces);
  } catch (err) {
    next(new AppError('Lỗi khi lấy danh sách tỉnh/thành', 500, 'GET_PROVINCES_ERROR'));
  }
};

const getDistrictsByProvince = async (req, res, next) => {
  try {
    const provinceCode = parseInt(req.params.provinceCode);
    if (isNaN(provinceCode)) return next(new AppError('provinceCode không hợp lệ', 400, 'INVALID_PROVINCE_CODE'));
    const districts = await District.find({ province_code: provinceCode });
    res.json(districts);
  } catch (err) {
    next(new AppError('Lỗi khi lấy danh sách quận/huyện', 500, 'GET_DISTRICTS_ERROR'));
  }
};

const getWardsByDistrict = async (req, res, next) => {
  try {
    const districtCode = parseInt(req.params.districtCode);
    if (isNaN(districtCode)) return next(new AppError('districtCode không hợp lệ', 400, 'INVALID_DISTRICT_CODE'));
    const wards = await Ward.find({ district_code: districtCode });
    res.json(wards);
  } catch (err) {
    next(new AppError('Lỗi khi lấy danh sách phường/xã', 500, 'GET_WARDS_ERROR'));
  }
};

const postDistrictsByProvince = async (req, res, next) => {
  try {
    const { provinceCode } = req.body;
    if (!provinceCode) return next(new AppError('provinceCode là bắt buộc', 400, 'MISSING_PROVINCE_CODE'));

    const districts = await District.find({ province_code: provinceCode });
    res.json(districts);
  } catch (err) {
    next(new AppError('Lỗi khi lấy danh sách quận/huyện', 500, 'POST_DISTRICTS_ERROR'));
  }
};

const postWardsByDistrict = async (req, res, next) => {
  try {
    const { districtCode } = req.body;
    if (!districtCode) return next(new AppError('districtCode là bắt buộc', 400, 'MISSING_DISTRICT_CODE'));

    const wards = await Ward.find({ district_code: districtCode });
    res.json(wards);
  } catch (err) {
    next(new AppError('Lỗi khi lấy danh sách phường/xã', 500, 'POST_WARDS_ERROR'));
  }
};
module.exports = {
  getAllProvinces,
  getDistrictsByProvince,
  getWardsByDistrict,
  postDistrictsByProvince,
  postWardsByDistrict
};