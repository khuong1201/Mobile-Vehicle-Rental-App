const express = require('express');
const router = express.Router();
const locationController = require('../../controllers/location/location_controller');
const authMiddleware = require('../../middlewares/auth_middleware');

router.get('/provinces',authMiddleware, locationController.getAllProvinces);

router.get('/districts/:provinceCode',authMiddleware, locationController.getDistrictsByProvince);

router.get('/wards/:districtCode',authMiddleware, locationController.getWardsByDistrict);

router.post('/districts',authMiddleware, locationController.postDistrictsByProvince);

router.post('/wards',authMiddleware, locationController.postWardsByDistrict);

module.exports = router;
