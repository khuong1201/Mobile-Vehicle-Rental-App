const mongoose = require('mongoose');
const Brand = require('../../models/vehicles/brand_model');
const cloudinary = require('../../config/cloudinary_instance');
const AppError = require('../../utils/app_error');

// Get all brands
const GetAllBrands = async (req, res, next) => {
  try {
    const brands = await Brand.find();
    res.status(200).json({ success: true, data: brands });
  } catch (err) {
    next(err);
  }
};
const GetBrandByBrandId = async (req, res, next) => {
  try {
    const { brandId } = req.params;
    const brand = await Brand.findOne({ brandId });

    if (!brand) {
      return next(new AppError(`Không tìm thấy thương hiệu với brandId: ${brandId}`, 404, "BRAND_NOT_FOUND"));
    }

    res.status(200).json({ success: true, data: brand });
  } catch (err) {
    next(err)
  }
};
// Create brand
const CreateBrand = async (req, res, next) => {
  try {
    const { brandName } = req.body;
    const file = req.file;

    if (!brandName || !file) {
      return next(new AppError("Tên và logo thương hiệu là bắt buộc", 400, "MISSING_FIELDS"));
    }

    const existed = await Brand.findOne({ brandName });
    if (existed) return next(new AppError("Thương hiệu đã tồn tại", 400, "BRAND_EXISTS"));

    const brandLogo = {
      url: file.path,
      publicId: file.filename
    };

    const newBrand = await Brand.create({ brandName, brandLogo });
    res.status(201).json({ success: true, data: newBrand, message: 'Tạo thương hiệu thành công' });
  } catch (err) {
    next(err);
  }
};

// Update brand
const UpdateBrand = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { brandName } = req.body;
    const file = req.file;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return next(new AppError("ID không hợp lệ", 400, "INVALID_ID"));
    }

    const brand = await Brand.findById(id);
    if (!brand) {
      return next(new AppError("Không tìm thấy thương hiệu", 404, "BRAND_NOT_FOUND"));
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
  } catch (err) {
    next(err);
  }
};

const DeleteBrand = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) return next(new AppError("ID không hợp lệ", 400, "INVALID_ID"));
    const brand = await Brand.findById(id);
    if (!brand) return next(new AppError("Không tìm thấy thương hiệu", 404, "BRAND_NOT_FOUND"));
    if (brand.brandLogo?.publicId) {
      await cloudinary.uploader.destroy(brand.brandLogo.publicId);
    }
    await Brand.findByIdAndDelete(id);
    res.status(200).json({ success: true, message: 'Xóa thương hiệu thành công' });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  GetBrandByBrandId,
  GetAllBrands,
  CreateBrand,
  UpdateBrand,
  DeleteBrand
};
