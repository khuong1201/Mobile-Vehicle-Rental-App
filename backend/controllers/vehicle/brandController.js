const mongoose = require('mongoose');
const Brand = require('../../models/vehicles/brand_model');
const cloudinary = require('../../config/cloudinary_instance');

// Get all brands
const GetAllBrands = async (req, res) => {
  try {
    const brands = await Brand.find();
    res.status(200).json({ success: true, data: brands });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi lấy danh sách thương hiệu', error: error.message });
  }
};
const GetBrandByBrandId = async (req, res) => {
  try {
    const { brandId } = req.params;
    const brand = await Brand.findOne({ brandId });

    if (!brand) {
      return res.status(404).json({
        success: false,
        message: `Brand with brandId: ${brandId} not found`
      });
    }

    res.status(200).json({ success: true, data: brand });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving brand',
      error: error.message
    });
  }
};
// Create brand
const CreateBrand = async (req, res) => {
  try {
    const { brandName } = req.body;
    const file = req.file;

    if (!brandName || !file) {
      return res.status(400).json({ success: false, message: 'Thiếu tên hoặc logo thương hiệu' });
    }

    const existed = await Brand.findOne({ brandName });
    if (existed) {
      return res.status(400).json({ success: false, message: 'Thương hiệu đã tồn tại' });
    }

    const brandLogo = {
      url: file.path,
      publicId: file.filename
    };

    const newBrand = await Brand.create({ brandName, brandLogo });
    res.status(201).json({ success: true, data: newBrand, message: 'Tạo thương hiệu thành công' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi tạo thương hiệu', error: error.message });
  }
};

// Update brand
const UpdateBrand = async (req, res) => {
  try {
    const { id } = req.params;
    const { brandName } = req.body;
    const file = req.file;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ' });
    }

    const brand = await Brand.findById(id);
    if (!brand) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy thương hiệu' });
    }

    // Nếu có ảnh mới => xóa ảnh cũ trên Cloudinary
    let brandLogo = brand.brandLogo;
    if (file) {
      if (brandLogo?.publicId) {
        await cloudinary.uploader.destroy(brandLogo.publicId);
      }
      brandLogo = {
        url: file.path,
        publicId: file.filename
      };
    }

    brand.brandName = brandName || brand.brandName;
    brand.brandLogo = brandLogo;
    await brand.save();

    res.status(200).json({ success: true, data: brand, message: 'Cập nhật thương hiệu thành công' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi cập nhật thương hiệu', error: error.message });
  }
};

// Delete brand
const DeleteBrand = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: 'ID không hợp lệ' });
    }

    const brand = await Brand.findById(id);
    if (!brand) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy thương hiệu' });
    }

    // Xóa logo trên Cloudinary nếu có
    if (brand.brandLogo?.publicId) {
      await cloudinary.uploader.destroy(brand.brandLogo.publicId);
    }

    await Brand.findByIdAndDelete(id);
    res.status(200).json({ success: true, message: 'Xóa thương hiệu thành công' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi xóa thương hiệu', error: error.message });
  }
};

module.exports = {
  GetBrandByBrandId,
  GetAllBrands,
  CreateBrand,
  UpdateBrand,
  DeleteBrand
};
