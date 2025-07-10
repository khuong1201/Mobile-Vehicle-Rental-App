const User = require("../../models/user_model");
const { deleteFileFromCloudinary } = require("../../services/cloudinary_service");
const AppError = require("../../utils/app_error");

const UpdateDriverLicense = async (req, res, next) => {
  try {
    console.log("req.body:", req.body);
    console.log("req.files:", req.files);

    if (!req.body) return res.status(400).json({ message: "Yêu cầu thiếu nội dung" });

    const { typeOfDriverLicense, classLicense, licenseNumber } = req.body;
    const frontFile = req.files?.driverLicenseFront?.[0];
    const backFile = req.files?.driverLicenseBack?.[0];

    if (!typeOfDriverLicense || !classLicense || !licenseNumber) {
      return next(new AppError("Thiếu các trường bắt buộc", 400, "MISSING_LICENSE_FIELDS"));
    }

    if (!frontFile || !backFile) {
      return next(new AppError("Thiếu tệp giấy phép (mặt trước hoặc mặt sau)", 400, "MISSING_LICENSE_FILES"));
    }

    const user = await User.findById(req.user.id);
    if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

    const licenses = user.license || [];
    const index = licenses.findIndex((l) => l.classLicense === classLicense);
    const existing = index !== -1 ? licenses[index] : null;

    if (existing) {
      try {
        if (existing.driverLicenseFrontPublicId) {
          await deleteFileFromCloudinary(existing.driverLicenseFrontPublicId);
          console.log(`Xóa ảnh mặt trước cũ: ${existing.driverLicenseFrontPublicId}`);
        }
        if (existing.driverLicenseBackPublicId) {
          await deleteFileFromCloudinary(existing.driverLicenseBackPublicId);
          console.log(`Xóa ảnh mặt sau cũ: ${existing.driverLicenseBackPublicId}`);
        }
      } catch (cloudinaryError) {
        return next(new AppError("Lỗi xóa ảnh cũ trên Cloudinary", 500, "CLOUDINARY_DELETE_FAILED"));
      }
    }

    const frontUrl = frontFile.path;
    const backUrl = backFile.path;
    const frontId = frontFile.filename;
    const backId = backFile.filename;

    const newLicense = {
      typeOfDriverLicense,
      classLicense,
      licenseNumber,
      driverLicenseFront: frontUrl,
      driverLicenseBack: backUrl,
      driverLicenseFrontPublicId: frontId,
      driverLicenseBackPublicId: backId,
      status: 'pending',
      ...(existing && { licenseId: existing.licenseId }), 
    };

    console.log("newLicense:", newLicense);

    if (existing) {
      Object.assign(user.license[index], newLicense);
    } else {
      user.license.push(newLicense);
    }

    await user.save();

    console.log("Saved user license:", user.license);

    res.json({
      message: "Cập nhật giấy phép lái xe thành công",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        license: user.license,
      },
    });
  } catch (err) {
    next(err);
  }
};

const DeleteDriverLicense = async (req, res, next) => {
  try {
    const { licenseId } = req.body;

    if (!licenseId)
      return next(new AppError("Thiếu licenseId để xóa", 400, "MISSING_LICENSE_ID"));

    const user = await User.findById(req.user.id);
    if (!user) return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));

    const licenses = user.license || [];
    const index = licenses.findIndex((l) => l.licenseId === licenseId);
    if (index === -1)
      return next(new AppError("Không tìm thấy giấy phép", 404, "LICENSE_NOT_FOUND"));

    const toDelete = licenses[index];
    try {
      if (toDelete.driverLicenseFrontPublicId)
        await deleteFileFromCloudinary(toDelete.driverLicenseFrontPublicId);
      if (toDelete.driverLicenseBackPublicId)
        await deleteFileFromCloudinary(toDelete.driverLicenseBackPublicId);
    } catch (cloudinaryError) {
      return next(new AppError("Lỗi khi xoá ảnh giấy phép", 500, "CLOUDINARY_DELETE_FAILED"));
    }

    licenses.splice(index, 1);
    user.license = licenses;

    await user.save();

    res.json({ message: "Xóa giấy phép lái xe thành công", license: user.license });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  UpdateDriverLicense,
  DeleteDriverLicense,
};