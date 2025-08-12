const express = require('express');
const router = express.Router();
const { 
  searchPlace, 
  reverseGeocode, 
  forwardGeocode 
} = require('../../services/google_api_service');
const authMiddleware = require('../../middlewares/auth_middleware');

router.post('/searchPlace', authMiddleware, searchPlace);

router.post('/reverseGeocode', authMiddleware, reverseGeocode);

router.post('/forwardGeocode', authMiddleware, forwardGeocode);

module.exports = router;
