const express = require("express");
const router = express.Router();
const { createVietinBankPayment, handleVietinBankIPN } = require("../../controllers/payment/viettin_controller");
const  authenticateToken  = require("../../middlewares/auth_middleware");
router.post("/create-viettin", authenticateToken, createVietinBankPayment);
router.post("/viettin/ipn", handleVietinBankIPN);
module.exports = router;