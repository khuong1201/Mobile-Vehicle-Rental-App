const express = require('express');
const router = express.Router();
const userController = require('../../controllers/user/user_change_password_controller');
const authenticateToken = require('../../middlewares/auth_middleware');
const userProfileController = require('../../controllers/user/user_profile_controller');
const userLicenseController = require('../../controllers/user/user_license_controller');
const userAddressController = require('../../controllers/user/user_address_controller');
const uploadUserLicense = require('../../middlewares/multer/upload_user_license');
const emailService = require('../../services/google_api_service');
const userUpdateRoleController = require('../../controllers/user/user_update_role_controller');
const { CheckOwnerMonthlyTax } = require('../../controllers/user/user_revenue_controller');

router.post('/change-password', authenticateToken, userController.ChangePassword);

router.put('/update-personal-info', authenticateToken, userProfileController.UpdatePersonalInfo);
router.get('/get-user-profile', authenticateToken, userProfileController.GetUserProfile);
router.put('/update-role', authenticateToken, userUpdateRoleController.UpdateUserRole);
router.post(
  '/create-license',
  authenticateToken,
  uploadUserLicense,
  userLicenseController.CreateDriverLicense
);

router.put(
  '/update-license',
  authenticateToken,
  uploadUserLicense,
  userLicenseController.UpdateDriverLicense
);

router.delete(
  '/delete-license',
  authenticateToken,
  userLicenseController.DeleteDriverLicense
);

router.get('/get-Address', authenticateToken, userAddressController.GetAddresses);
router.put('/update-Address', authenticateToken, userAddressController.UpdateAddress);
router.delete('/delete-Address', authenticateToken, userAddressController.DeleteAddress);
router.post('/place/search', authenticateToken, emailService.searchPlace );

router.get('/owner/:userId/monthly-tax', CheckOwnerMonthlyTax);

module.exports = router;