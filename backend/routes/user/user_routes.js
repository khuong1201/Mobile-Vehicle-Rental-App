const express = require('express');
const router = express.Router();
const userController = require('../../controllers/user/user_change_password_controller');
const authenticateToken = require('../../middlewares/auth_middleware');
const userProfileController = require('../../controllers/user/user_profile_controller');
const userLicenseController = require('../../controllers/user/user_license_controller');
const userAddressController = require('../../controllers/user/user_address_controller');
const adminMiddleware = require('../../middlewares/admin_middleware');

router.post('/change-password', authenticateToken, userController.ChangePassword);

router.put('/update-PersonalInfo', authenticateToken, userProfileController.UpdatePersonalInfo);
router.get('/get-user-profile', authenticateToken, userProfileController.GetUserProfile);

router.delete('/delete-DriverLicense', authenticateToken, userLicenseController.DeleteDriverLicense);
router.put('/update-DriverLicense', authenticateToken, userLicenseController.UpdateDriverLicense);
router.get('/get-DriverLicense', authenticateToken, userLicenseController.GetDriverLicenses);

router.get('/get-Address', authenticateToken, userAddressController.GetAddresses);
router.put('/update-Address', authenticateToken, userAddressController.UpdateAddress);
router.delete('/delete-Address', authenticateToken, userAddressController.DeleteAddress);

module.exports = router;