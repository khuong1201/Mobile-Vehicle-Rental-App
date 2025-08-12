const express = require('express');
const router = express.Router();
const {
  getAllProvinces,
  getDistrictsByProvince,
  getWardsByDistrict,
  postDistrictsByProvince,
  postWardsByDistrict
} = require('../../controllers/location/location_controller');

router.get('/provinces', getAllProvinces);
router.get('/provinces/:provinceCode/districts', getDistrictsByProvince);
router.get('/districts/:districtCode/wards', getWardsByDistrict);

router.post('/provinces/districts', postDistrictsByProvince);
router.post('/districts/wards', postWardsByDistrict);

module.exports = router;
