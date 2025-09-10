import IStorageAdapter from "./i_storage_adapter.js";
import cloudinary from "../../config/cloudinary.js";
import AppError from "../../utils/app_error.js";

function bufferToDataUri(file) {
  const base64 = file.buffer.toString("base64");
  return `data:${file.mimetype};base64,${base64}`;
}

export default class CloudinaryAdapter extends IStorageAdapter {
  constructor(folderPrefix = "uploads") {
    super();
    this.folderPrefix = folderPrefix;
  }

  async upload(file, options = {}) {
    if (!file) throw new AppError("File is required");

    const folder = options.folder || this.folderPrefix;
    const publicId = options.publicId || `file_${Date.now()}`;

    const uploadSource = file.path ? file.path : bufferToDataUri(file);

    const result = await cloudinary.uploader.upload(uploadSource, {
      folder,
      public_id: publicId,
      resource_type: "image",
    });

    return {
      url: result.secure_url,
      publicId: result.public_id,
    };
  }

  async delete(publicId) {
    if (!publicId) throw new AppError("PublicId is required for delete");
    return cloudinary.uploader.destroy(publicId, { resource_type: "image" });
  }

  async getUrl(publicId) {
    if (!publicId) throw new AppError("PublicId is required to get URL");
    return cloudinary.url(publicId);
  }
}
