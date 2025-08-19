const mongoose = require("mongoose");
const Brand = require("../../models/vehicles/brand_model");
const cloudinary = require("../../config/cloudinary_instance");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const getAllBrands = asyncHandler(async (req, res) => {
  const { keyword } = req.query;
  let query = {};
  if (keyword) {
    query.brandName = { $regex: keyword, $options: "i" };
  }
  const brands = await Brand.find(query);
  res.success(brands, "Fetched all brands successfully");
});

const getBrandByBrandId = asyncHandler(async (req, res, next) => {
  const { brandId } = req.params;
  const brand = await Brand.findOne({ brandId });

  if (!brand) {
    return next(new AppError(`Brand not found with brandId: ${brandId}`, 404, "BRAND_NOT_FOUND"));
  }

  res.success(brand, "Fetched brand successfully");
});

const createBrand = asyncHandler(async (req, res, next) => {
  const { brandName } = req.body;
  const file = req.file;

  if (!brandName || !file) {
    return next(new AppError("Brand name and logo are required", 400, "MISSING_FIELDS"));
  }

  const existed = await Brand.findOne({ brandName });
  if (existed) {
    return next(new AppError("Brand already exists", 400, "BRAND_EXISTS"));
  }

  const brandLogo = {
    url: file.path,
    publicId: file.filename,
  };

  const newBrand = await Brand.create({ brandName, brandLogo });
  res.success(newBrand, "Brand created successfully", 201);
});

const updateBrand = asyncHandler(async (req, res, next) => {
  const { id } = req.params;
  const { brandName } = req.body;
  const file = req.file;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return next(new AppError("Invalid ID", 400, "INVALID_ID"));
  }

  const brand = await Brand.findById(id);
  if (!brand) {
    return next(new AppError("Brand not found", 404, "BRAND_NOT_FOUND"));
  }

  let brandLogo = brand.brandLogo;
  if (file) {
    if (brandLogo?.publicId) {
      await cloudinary.uploader.destroy(brandLogo.publicId);
    }
    brandLogo = {
      url: file.path,
      publicId: file.filename,
    };
  }

  brand.brandName = brandName || brand.brandName;
  brand.brandLogo = brandLogo;
  await brand.save();

  res.success(brand, "Brand updated successfully");
});

const deleteBrand = asyncHandler(async (req, res, next) => {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return next(new AppError("Invalid ID", 400, "INVALID_ID"));
  }

  const brand = await Brand.findById(id);
  if (!brand) {
    return next(new AppError("Brand not found", 404, "BRAND_NOT_FOUND"));
  }

  if (brand.brandLogo?.publicId) {
    await cloudinary.uploader.destroy(brand.brandLogo.publicId);
  }

  await Brand.findByIdAndDelete(id);
  res.success(null, "Brand deleted successfully");
});

module.exports = {
  getAllBrands,
  getBrandByBrandId,
  createBrand,
  updateBrand,
  deleteBrand,
};
