const express = require('express');
const router = express.Router();

const adminController = require('../../controllers/admin/admin_user_controller');
const adminMiddleware = require('../../middlewares/admin_middleware');
const authenticateToken = require('../../middlewares/auth_middleware');

router.delete('/delete-account', authenticateToken,adminMiddleware, adminController.DeleteAccount);
router.get('/get-all-user', authenticateToken, adminMiddleware, adminController.GetAllUsers);
router.get('/get-users-with-unapproved-licenses', authenticateToken, adminMiddleware, adminController.GetUsersWithUnapprovedLicenses);
router.post('/approve-license', authenticateToken, adminMiddleware, adminController.ApproveLicense);
router.post('/reject-license', authenticateToken, adminMiddleware, adminController.RejectLicense);
router.get('/get-user-profile', authenticateToken, adminMiddleware, adminController.GetUser);


module.exports = router;