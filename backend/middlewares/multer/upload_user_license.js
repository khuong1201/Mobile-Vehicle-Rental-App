const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const cloudinary = require("../../config/cloudinary_instance");

const storage = new CloudinaryStorage({
  cloudinary,
  params: (req, file) => {
    let folder = "user_licenses/others";
    if (req.user?.id) {
      folder = `user_licenses/${req.user.id}`;
    }

    return {
      folder,
      allowed_formats: ["jpg", "jpeg", "png"],
      public_id: `${Date.now()}_${file.originalname}`,
      resource_type: "image",
    };
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    const allowedTypes = ["image/jpeg", "image/png"];
    if (!allowedTypes.includes(file.mimetype)) {
      return cb(new Error("Chỉ chấp nhận tệp JPG hoặc PNG"));
    }
    cb(null, true);
  },
});

module.exports = upload.fields([
  { name: "driverLicenseFront", maxCount: 1 },
  { name: "driverLicenseBack", maxCount: 1 },
]);