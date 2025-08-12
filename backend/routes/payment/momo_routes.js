const express = require("express");
const router = express.Router();
const { createMoMoPayment, handleMoMoIPN } = require("../../controllers/payment/momo_controller");
const authenticateToken = require("../../middlewares/auth_middleware");

router.post("/momo/create", authenticateToken, createMoMoPayment);
router.post("/momo/ipn", handleMoMoIPN);

module.exports = router;
