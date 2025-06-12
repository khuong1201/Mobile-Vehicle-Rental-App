const express = require('express');
const router = express.Router();

const adminController = require('../../controllers/admin/admin_user_controller');
const AdminMiddleware = require('../../middlewares/Admin_middleware');
const authenticateToken = require('../../middlewares/auth_middleware');

router.delete('/delete-account', authenticateToken,AdminMiddleware, adminController.deleteAccount);
router.get('/get-all-user', authenticateToken, AdminMiddleware, adminController.getAllUsers);
router.get('/get-users-with-unapproved-licenses', authenticateToken, AdminMiddleware, adminController.getUsersWithUnapprovedLicenses);
router.post('/approve-license', authenticateToken, AdminMiddleware, adminrController.approveLicense);
router.post('/reject-license', authenticateToken, AdminMiddleware, adminController.rejectLicense);
router.get('/get-user-profile', authenticateToken, AdminMiddleware, adminController.getUser);


module.exports = router;