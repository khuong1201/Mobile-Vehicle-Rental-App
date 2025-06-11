const express = require('express');
const router = express.Router();
const brandController = require('../../controllers/vehicle/brandController');

// [GET] /api/brands - Lấy tất cả hãng xe
router.get('/', brandController.getAllBrands);

// [POST] /api/brands - Thêm hãng xe mới
router.post('/', brandController.createBrand);

// [PUT] /api/brands/:id - Cập nhật hãng xe theo ObjectId
router.put('/:id', brandController.updateBrand);

// [DELETE] /api/brands/:id - Xóa hãng xe theo ObjectId
router.delete('/:id', brandController.deleteBrand);

module.exports = router;
