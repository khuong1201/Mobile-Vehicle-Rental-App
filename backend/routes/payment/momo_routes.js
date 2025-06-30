const express = require("express");
const router = express.Router();
const { createMoMoPayment } = require("../../controllers/payment/momo_controller");
const { authenticateUser } = require("../../middlewares/auth_middleware");
router.post("/momo-create", authenticateUser, createMoMoPayment);

module.exports = router;