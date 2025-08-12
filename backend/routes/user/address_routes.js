const express = require('express');
const router = express.Router();
const userAddressController = require('../../controllers/user/address_controller');

router.get('/addresses', userAddressController.getAddresses);

router.put('/addresses', userAddressController.updateAddress);

router.delete('/addresses', userAddressController.deleteAddress);

module.exports = router;