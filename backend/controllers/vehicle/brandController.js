const mongoose = require('mongoose');
const Brand = require('../../models/brand_model');

// Lấy tất cả hãng xe
const getAllBrands = async (req, res) => {
  try {
    const brands = await Brand.find();
    res.status(200).json({
      success: true,
      data: brands
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách hãng xe',
      error: error.message
    });
  }
};

// Thêm hãng xe mới
const createBrand = async (req, res) => {
  try {
    const { brand } = req.body;
    if (!brand) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp tên hãng xe'
      });
    }
    // Tạo brandId tự động
    let lastBrand = await Brand.findOne().sort({ brandId: -1 });
    let nextNumber = 1;
    if (lastBrand && lastBrand.brandId && lastBrand.brandId.startsWith('BR')) {
      const number = parseInt(lastBrand.brandId.replace('BR', ''), 10);
      if (!isNaN(number)) {
        nextNumber = number + 1;
      }
    }
    const brandId = 'BR' + String(nextNumber).padStart(2, '0');
    // Kiểm tra brandId đã tồn tại chưa
    const idExists = await Brand.findOne({ brandId });
    if (idExists) {
      return res.status(400).json({
        success: false,
        message: `brandId ${brandId} đã tồn tại`
      });
    }
    // Tạo hãng xe mới
    const newBrand = await Brand.create({ brandId, brand });
    res.status(201).json({
      success: true,
      data: newBrand,
      message: 'Thêm hãng xe thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm hãng xe',
      error: error.message
    });
  }
};

// Sửa hãng xe theo ID
const updateBrand = async (req, res) => {
  try {
    const { id } = req.params;
    const { brand } = req.body;

    // Kiểm tra ID có hợp lệ không
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: 'ID hãng xe không hợp lệ, vui lòng cung cấp ObjectId hợp lệ'
      });
    }

    // Kiểm tra tên hãng xe
    if (!brand) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp tên hãng xe'
      });
    }

    // Cập nhật hãng xe (không sửa brandId)
    const updatedBrand = await Brand.findByIdAndUpdate(
      id,
      { brand },
      { new: true, runValidators: true }
    );
    if (!updatedBrand) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy hãng xe với ID này'
      });
    }

    res.status(200).json({
      success: true,
      data: updatedBrand,
      message: 'Cập nhật hãng xe thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật hãng xe',
      error: error.message
    });
  }
};

// Xóa hãng xe theo ID
const deleteBrand = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra ID có hợp lệ không
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: 'ID hãng xe không hợp lệ, vui lòng cung cấp ObjectId hợp lệ'
      });
    }

    const deletedBrand = await Brand.findByIdAndDelete(id);
    if (!deletedBrand) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy hãng xe với ID này'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Xóa hãng xe thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa hãng xe',
      error: error.message
    });
  }
};

module.exports = {
  getAllBrands,
  createBrand,
  updateBrand,
  deleteBrand
};