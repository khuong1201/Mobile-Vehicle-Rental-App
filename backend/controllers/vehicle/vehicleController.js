const mongoose = require('mongoose');
const Vehicle = require('../../models/vehicle_model');
const Brand = require('../../models/brand_model');

// Lấy tất cả xe
const getAllVehicles = async (req, res) => {
  try {
    const vehicles = await Vehicle.find().populate('brand'); // Lấy thông tin hãng xe
    res.status(200).json({
      success: true,
      data: vehicles
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách xe',
      error: error.message
    });
  }
};

// Thêm xe mới
const createVehicle = async (req, res) => {
  try {
    const { vehicleName, brandId, type, priceRentalMin, priceRentalMax } = req.body;
    // Kiểm tra các trường bắt buộc
    if (!vehicleName || !brandId || !type || !priceRentalMin || !priceRentalMax) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp đầy đủ thông tin: vehicleName, brandId, type, priceRentalMin, priceRentalMax'
      });
    }
    // Kiểm tra hãng xe có tồn tại không
    if (!mongoose.Types.ObjectId.isValid(brandId)) {
      return res.status(400).json({
        success: false,
        message: 'ID hãng xe không hợp lệ, vui lòng cung cấp ObjectId hợp lệ'
      });
    }
    const brand = await Brand.findById(brandId);
    if (!brand) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy hãng xe với ID này'
      });
    }
    // Tạo vehicleId tự động
    let lastVehicle = await Vehicle.findOne().sort({ vehicleId: -1 });
    let nextNumber = 1;
    if (lastVehicle && lastVehicle.vehicleId && lastVehicle.vehicleId.startsWith('VH')) {
      const number = parseInt(lastVehicle.vehicleId.replace('VH', ''), 10);
      if (!isNaN(number)) {
        nextNumber = number + 1;
      }
    }
    const vehicleId = 'VH' + String(nextNumber).padStart(2, '0');
    // Kiểm tra vehicleId đã tồn tại chưa
    const idExists = await Vehicle.findOne({ vehicleId });
    if (idExists) {
      return res.status(400).json({
        success: false,
        message: `vehicleId ${vehicleId} đã tồn tại`
      });
    }
    // Tạo xe mới
    const newVehicle = await Vehicle.create({
      vehicleId,
      vehicleName,
      brand: brandId,
      type,
      priceRentalMin,
      priceRentalMax
    });
    res.status(201).json({
      success: true,
      data: newVehicle,
      message: 'Thêm xe thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm xe',
      error: error.message
    });
  }
};

// Sửa xe theo ID
const updateVehicle = async (req, res) => {
  try {
    const { id } = req.params;
    const { vehicleName, brandId, type, priceRentalMin, priceRentalMax } = req.body;

    // Kiểm tra ID xe có hợp lệ không
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: 'ID xe không hợp lệ, vui lòng cung cấp ObjectId hợp lệ'
      });
    }

    // Kiểm tra hãng xe nếu brandId được cung cấp
    if (brandId) {
      if (!mongoose.Types.ObjectId.isValid(brandId)) {
        return res.status(400).json({
          success: false,
          message: 'ID hãng xe không hợp lệ, vui lòng cung cấp ObjectId hợp lệ'
        });
      }
      const brand = await Brand.findById(brandId);
      if (!brand) {
        return res.status(404).json({
          success: false,
          message: 'Không tìm thấy hãng xe với ID này'
        });
      }
    }

    // Cập nhật xe
    const updatedVehicle = await Vehicle.findByIdAndUpdate(
      id,
      {
        vehicleName,
        brand: brandId,
        type,
        priceRentalMin,
        priceRentalMax
      },
      { new: true, runValidators: true }
    );
    if (!updatedVehicle) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy xe với ID này'
      });
    }
    res.status(200).json({
      success: true,
      data: updatedVehicle,
      message: 'Cập nhật xe thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật xe',
      error: error.message
    });
  }
};

// Xóa xe theo ID
const deleteVehicle = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra ID có hợp lệ không
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: 'ID xe không hợp lệ, vui lòng cung cấp ObjectId hợp lệ'
      });
    }

    const deletedVehicle = await Vehicle.findByIdAndDelete(id);
    if (!deletedVehicle) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy xe với ID này'
      });
    }
    res.status(200).json({
      success: true,
      message: 'Xóa xe thành công'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa xe',
      error: error.message
    });
  }
};

module.exports = {
  getAllVehicles,
  createVehicle,
  updateVehicle,
  deleteVehicle
};