const express = require('express');
const router = express.Router();
const { searchPlace, reverseGeocode, forwardGeocode } = require('../../services/google_api_service');
const authMiddleware = require('../../middlewares/auth_middleware');
router.post('/search-place',authMiddleware, searchPlace);

router.post('/reverse-geocode',authMiddleware, reverseGeocode);

router.post('/forward-geocode',authMiddleware, forwardGeocode);

module.exports = router;
