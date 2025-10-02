import multer from "multer";
import { extname } from "path";

const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
  const allowedMimeTypes = ["image/jpeg", "image/png", "image/jpg"];
  const allowedExtensions = [".jpg", ".jpeg", ".png"];
  const fileExt = extname(file.originalname).toLowerCase();

  if (!allowedMimeTypes.includes(file.mimetype) || !allowedExtensions.includes(fileExt)) {
    return cb(new Error("Only JPG/PNG files are allowed"), false);
  }
  cb(null, true);
};

const uploadLicense = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, 
  fileFilter,
});

export default uploadLicense.fields([
  { name: "driverLicenseFront", maxCount: 1 },
  { name: "driverLicenseBack", maxCount: 1 },
]);
