const { Province, District, Ward } = require('../../models/location/location_in_vietnam_model');

const getAllProvinces = async (req, res) => {
  try {
    const provinces = await Province.find();
    res.json(provinces);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách tỉnh/thành', error: err.message });
  }
};

const getDistrictsByProvince = async (req, res) => {
  try {
    const provinceCode = parseInt(req.params.provinceCode);
    const districts = await District.find({ province_code: provinceCode });
    res.json(districts);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách quận/huyện', error: err.message });
  }
};

const getWardsByDistrict = async (req, res) => {
  try {
    const districtCode = parseInt(req.params.districtCode);
    const wards = await Ward.find({ district_code: districtCode });
    res.json(wards);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách phường/xã', error: err.message });
  }
};

const postDistrictsByProvince = async (req, res) => {
  try {
    const { provinceCode } = req.body;
    if (!provinceCode) return res.status(400).json({ message: 'provinceCode là bắt buộc' });

    const districts = await District.find({ province_code: provinceCode });
    res.json(districts);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách quận/huyện', error: err.message });
  }
};

const postWardsByDistrict = async (req, res) => {
  try {
    const { districtCode } = req.body;
    if (!districtCode) return res.status(400).json({ message: 'districtCode là bắt buộc' });

    const wards = await Ward.find({ district_code: districtCode });
    res.json(wards);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách phường/xã', error: err.message });
  }
};
module.exports = {
  getAllProvinces,
  getDistrictsByProvince,
  getWardsByDistrict,
  postDistrictsByProvince,
  postWardsByDistrict
};