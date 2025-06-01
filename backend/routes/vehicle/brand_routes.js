const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brandController');

// Lấy tất cả hãng xe
router.get('/', brandController.getAllBrands);

// Thêm hãng xe mới
router.post('/', brandController.createBrand);

// Sửa hãng xe theo ID
router.put('/:id', brandController.updateBrand);

// Xóa hãng xe theo ID
router.delete('/:id', brandController.deleteBrand);

module.exports = router;