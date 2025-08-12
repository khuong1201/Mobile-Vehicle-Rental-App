const express = require('express');
const router = express.Router();
const userRoleController = require('../../controllers/user/role_controller');

router.put('/update-role', userRoleController.updateUserRole);

module.exports = router;
