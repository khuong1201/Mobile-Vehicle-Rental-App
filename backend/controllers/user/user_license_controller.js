const User = require("../../models/user_model");
const { deleteFileFromCloudinary } = require("../../services/cloudinary_service");

const UpdateDriverLicense = async (req, res) => {
  try {
    console.log("req.body:", req.body);
    console.log("req.files:", req.files);

    if (!req.body) return res.status(400).json({ message: "Yêu cầu thiếu nội dung" });

    const { typeOfDriverLicense, classLicense, licenseNumber } = req.body;
    const frontFile = req.files?.driverLicenseFront?.[0];
    const backFile = req.files?.driverLicenseBack?.[0];

    if (!typeOfDriverLicense || !classLicense || !licenseNumber)
      return res.status(400).json({ message: "Thiếu các trường bắt buộc: typeOfDriverLicense, classLicense, hoặc licenseNumber" });

    if (!frontFile || !backFile)
      return res.status(400).json({ message: "Thiếu tệp giấy phép (mặt trước hoặc mặt sau)" });

    if (!frontFile.path || !backFile.path)
      return res.status(500).json({ message: "Không thể lấy URL ảnh từ Cloudinary" });

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "Không tìm thấy người dùng" });

    const licenses = user.license || [];
    const index = licenses.findIndex((l) => l.classLicense === classLicense);
    const existing = index !== -1 ? licenses[index] : null;

    // Xóa ảnh cũ trên Cloudinary nếu giấy phép đã tồn tại
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
        console.error("Lỗi xóa ảnh cũ trên Cloudinary:", cloudinaryError.message);
        return res.status(500).json({ message: "Lỗi xóa ảnh cũ trên Cloudinary" });
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
      ...(existing && { licenseId: existing.licenseId }), // Bảo toàn licenseId
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
    console.error("Lỗi cập nhật giấy phép lái xe:", err.message);
    res.status(500).json({ message: "Không thể cập nhật giấy phép lái xe: " + err.message });
  }
};

const DeleteDriverLicense = async (req, res) => {
  try {
    const { licenseId } = req.body;

    if (!licenseId)
      return res.status(400).json({ message: "Thiếu licenseId để xóa" });

    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "Không tìm thấy người dùng" });

    const licenses = user.license || [];
    const index = licenses.findIndex((l) => l.licenseId === licenseId);
    if (index === -1)
      return res.status(404).json({ message: "Không tìm thấy giấy phép với licenseId cung cấp" });

    const toDelete = licenses[index];
    try {
      if (toDelete.driverLicenseFrontPublicId)
        await deleteFileFromCloudinary(toDelete.driverLicenseFrontPublicId);
      if (toDelete.driverLicenseBackPublicId)
        await deleteFileFromCloudinary(toDelete.driverLicenseBackPublicId);
    } catch (cloudinaryError) {
      console.error("Lỗi xóa ảnh trên Cloudinary:", cloudinaryError.message);
      return res.status(500).json({ message: "Lỗi xóa ảnh trên Cloudinary" });
    }

    licenses.splice(index, 1);
    user.license = licenses;

    await user.save();

    res.json({ message: "Xóa giấy phép lái xe thành công", license: user.license });
  } catch (err) {
    console.error("Lỗi xóa giấy phép lái xe:", err.message);
    res.status(500).json({ message: "Không thể xóa giấy phép lái xe: " + err.message });
  }
};

module.exports = {
  UpdateDriverLicense,
  DeleteDriverLicense,
};