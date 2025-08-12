const express = require('express');
const router = express.Router();
const { checkOwnerMonthlyTax } = require('../../controllers/user/revenue_controller');

router.get('/owner/:userId/monthly-tax', checkOwnerMonthlyTax);

module.exports = router;
