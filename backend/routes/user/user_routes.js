const express = require('express');
const router = express.Router();
const userController = require('../../controllers/user/user_change_password_controller');
const authenticateToken = require('../../middlewares/auth_middleware');
const userProfileController = require('../../controllers/user/user_profile_controller');
const userLicenseController = require('../../controllers/user/user_license_controller');
const userAddressController = require('../../controllers/user/user_address_controller');
const AdminMiddleware = require('../../middlewares/Admin_middleware');

router.post('/change-password', authenticateToken, userController.changePassword);

router.put('/update-PersonalInfo', authenticateToken, userProfileController.updatePersonalInfo);
router.get('/get-user-profile', authenticateToken, userProfileController.getUserProfile);

router.delete('/delete-DriverLicense', authenticateToken, userLicenseController.deleteDriverLicense);
router.put('/update-DriverLicense', authenticateToken, userLicenseController.updateDriverLicense);
router.get('/get-DriverLicense', authenticateToken, userLicenseController.getDriverLicenses);

router.get('/get-Address', authenticateToken, userAddressController.getAddresses);
router.put('/update-Address', authenticateToken, userAddressController.updateAddress);
router.delete('/delete-Address', authenticateToken, userAddressController.deleteAddress);

module.exports = router;