const express = require('express');
const router = express.Router();
const locationController = require('../../controllers/location/location_controller');


router.get('/provinces', locationController.getAllProvinces);

router.get('/districts/:provinceCode', locationController.getDistrictsByProvince);

router.get('/wards/:districtCode', locationController.getWardsByDistrict);

router.post('/districts', locationController.postDistrictsByProvince);

router.post('/wards', locationController.postWardsByDistrict);

module.exports = router;
