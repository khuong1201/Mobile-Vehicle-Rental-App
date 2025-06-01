const express = require('express');
const router = express.Router();
const userController = require('../../controllers/user/userController');
const authenticateToken = require('../../middlewares/auth_middleware');

router.post('/change-password', authenticateToken, userController.changePassword);
router.delete('/delete-account', authenticateToken, userController.deleteAccount);
router.put('/update-details', authenticateToken, userController.updateDetails);

module.exports = router;