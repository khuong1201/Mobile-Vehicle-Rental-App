const express = require('express');
const router = express.Router();
const emailService = require('../../services/google_api_service');

router.post('/place/search', emailService.searchPlace);

module.exports = router;
