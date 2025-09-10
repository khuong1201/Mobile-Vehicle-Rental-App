import fs from "fs";
import path from "path";
import IStorageAdapter from "./i_storage_adapter.js";

export default class LocalAdapter extends IStorageAdapter {
  constructor(basePath = "uploads") {
    super();
    this.basePath = basePath;
  }

  async upload(file, options = {}) {
    const folder = path.join(this.basePath, options.folder || "");
    if (!fs.existsSync(folder)) fs.mkdirSync(folder, { recursive: true });

    const fileName = options.publicId || `${Date.now()}_${file.originalname}`;
    const destPath = path.join(folder, fileName);

    fs.renameSync(file.path, destPath);

    return {
      url: `/uploads/${fileName}`,
      publicId: fileName,
    };
  }

  async delete(publicId) {
    const filePath = path.join(this.basePath, publicId);
    if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
    return true;
  }

  async getUrl(publicId) {
    return `/uploads/${publicId}`;
  }
}
