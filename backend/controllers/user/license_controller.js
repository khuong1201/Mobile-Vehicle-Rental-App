const User = require("../../models/user_model");
const { deleteFileFromCloudinary } = require("../../services/cloudinary_service");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const deleteOldLicenseImages = async (license) => {
  if (license.driverLicenseFrontPublicId) {
    await deleteFileFromCloudinary(license.driverLicenseFrontPublicId);
  }
  if (license.driverLicenseBackPublicId) {
    await deleteFileFromCloudinary(license.driverLicenseBackPublicId);
  }
};

const getDriverLicenses = asyncHandler(async (req, res, next) => {
  const user = await User.findById(req.user.id);
  if (!user) {
    return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));
  }

  res.json({
    message: "Lấy danh sách giấy phép lái xe thành công",
    license: user.license || [],
  });
});

const createDriverLicense = asyncHandler(async (req, res, next) => {
  const { typeOfDriverLicense, classLicense, licenseNumber } = req.body;
  const frontFile = req.files?.driverLicenseFront?.[0];
  const backFile = req.files?.driverLicenseBack?.[0];

  if (!typeOfDriverLicense || !classLicense || !licenseNumber) {
    return next(new AppError("Thiếu trường bắt buộc", 400, "MISSING_FIELDS"));
  }

  if (!frontFile || !backFile) {
    return next(new AppError("Thiếu ảnh mặt trước hoặc mặt sau", 400, "MISSING_LICENSE_FILES"));
  }

  const user = await User.findById(req.user.id);
  if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

  const exists = user.license?.some((l) => l.classLicense === classLicense);
  if (exists) {
    return next(new AppError("Đã tồn tại loại bằng này", 409, "LICENSE_ALREADY_EXISTS"));
  }

  const newLicense = {
    typeOfDriverLicense,
    classLicense,
    licenseNumber,
    driverLicenseFront: frontFile.path,
    driverLicenseBack: backFile.path,
    driverLicenseFrontPublicId: frontFile.filename,
    driverLicenseBackPublicId: backFile.filename,
    status: "pending",
  };

  user.license.push(newLicense);
  await user.save();

  res.json({
    message: "Tạo giấy phép lái xe thành công",
    license: user.license,
  });
});

const updateDriverLicense = asyncHandler(async (req, res, next) => {
  const { classLicense, typeOfDriverLicense, licenseNumber } = req.body;
  const frontFile = req.files?.driverLicenseFront?.[0];
  const backFile = req.files?.driverLicenseBack?.[0];

  if (!classLicense || !typeOfDriverLicense || !licenseNumber) {
    return next(new AppError("Thiếu trường bắt buộc", 400, "MISSING_FIELDS"));
  }

  const user = await User.findById(req.user.id);
  if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

  const index = user.license?.findIndex((l) => l.classLicense === classLicense);
  if (index === -1) {
    return next(new AppError("Không tìm thấy license", 404, "LICENSE_NOT_FOUND"));
  }

  const license = user.license[index];
  await deleteOldLicenseImages(license);

  user.license[index] = {
    ...license,
    typeOfDriverLicense,
    licenseNumber,
    classLicense: classLicense || license.classLicense,
    driverLicenseFront: frontFile ? frontFile.path : license.driverLicenseFront,
    driverLicenseBack: backFile ? backFile.path : license.driverLicenseBack,
    driverLicenseFrontPublicId: frontFile
      ? frontFile.filename
      : license.driverLicenseFrontPublicId,
    driverLicenseBackPublicId: backFile
      ? backFile.filename
      : license.driverLicenseBackPublicId,
    status: "pending",
  };

  await user.save();

  res.json({
    message: "Cập nhật giấy phép lái xe thành công",
    license: user.license,
  });
});

const deleteDriverLicense = asyncHandler(async (req, res, next) => {
  const { licenseId } = req.body;
  if (!licenseId) {
    return next(new AppError("Thiếu licenseId", 400, "MISSING_LICENSE_ID"));
  }

  const user = await User.findById(req.user.id);
  if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

  const index = user.license?.findIndex((l) => l.licenseId === licenseId);
  if (index === -1) {
    return next(new AppError("Không tìm thấy license", 404, "LICENSE_NOT_FOUND"));
  }

  const license = user.license[index];
  await deleteOldLicenseImages(license);

  user.license.splice(index, 1);
  await user.save();

  res.json({
    message: "Xoá giấy phép thành công",
    license: user.license,
  });
});

module.exports = {
  getDriverLicenses,
  createDriverLicense,
  updateDriverLicense,
  deleteDriverLicense,
};
