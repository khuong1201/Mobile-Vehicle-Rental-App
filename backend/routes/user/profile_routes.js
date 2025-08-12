const express = require('express');
const router = express.Router();
const userProfileController = require('../../controllers/user/profile_controller');

router.put('/update-personal-info', userProfileController.updatePersonalInfo);

router.get('/get-user-profile', userProfileController.getUserProfile);

module.exports = router;