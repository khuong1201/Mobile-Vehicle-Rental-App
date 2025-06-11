const express = require('express');
const router = express.Router();
const userController = require('../../controllers/user/user_controller');
const authenticateToken = require('../../middlewares/auth_middleware');
const userProfileController = require('../../controllers/user/user_profile_controller');
const userLicenseController = require('../../controllers/user/user_license_controller');
const userAddressController = require('../../controllers/user/user_address_controller');

router.post('/change-password', authenticateToken, userController.changePassword);
router.delete('/delete-account', authenticateToken, userController.deleteAccount);
router.get('/get-user-profile', authenticateToken, userController.getUserProfile);

router.put('/update-PersonalInfo', authenticateToken, userProfileController.updatePersonalInfo);

router.delete('/delete-DriverLicense', authenticateToken, userLicenseController.deleteDriverLicense);
router.put('/update-DriverLicense', authenticateToken, userLicenseController.updateDriverLicense);
router.get('/get-DriverLicense', authenticateToken, userLicenseController.getDriverLicenses);

router.get('/get-Address', authenticateToken, userAddressController.getAddress);
router.put('/update-Address', authenticateToken, userAddressController.updateAddress);
router.delete('/delete-Address', authenticateToken, userAddressController.deleteAddress);

module.exports = router;