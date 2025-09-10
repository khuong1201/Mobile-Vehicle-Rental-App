import AppError from "../utils/app_error.js";

export default class BannerService {
  constructor(bannerRepo, validator, storage) {
    this.bannerRepo = bannerRepo;
    this.validator = validator;
    this.storage = storage;
  }

  async uploadImage(file) {
    if (!file) return null;
    if (!file.mimetype?.startsWith("image/")) {
      throw new AppError("Banner image must be an image", 400);
    }
    const uploaded = await this.storage.upload(file, { folder: "banners" });
    return {
      url: uploaded.url,
      publicId: uploaded.publicId,
    };
  }

  async createBanner(payload, file) {
    this.validator.validateCreate(payload);

    const bannerImage = await this.uploadImage(file);
    return this.bannerRepo.create({ ...payload, bannerImage });
  }

  async updateBanner(bannerId, payload, file) {
    this.validator.validateUpdate(payload);

    const banner = await this.bannerRepo.findById(bannerId);
    if (!banner) throw new AppError("Banner not found", 404);

    let bannerImage = banner.bannerImage;
    if (file) {
      if (bannerImage?.publicId) {
        await this.storage.delete(bannerImage.publicId);
      }
      bannerImage = await this.uploadImage(file);
    }

    return this.bannerRepo.update(bannerId, { ...payload, bannerImage });
  }

  async deleteBanner(bannerId) {
    return this.bannerRepo.update(bannerId, { deleted: true });
  }

  async listBanners(options = {}) {
    return this.bannerRepo.find({ deleted: false }, options);
  }

  async getBanner(bannerId) {
    const banner = await this.bannerRepo.findById(bannerId);
    if (!banner || banner.deleted) throw new AppError("Banner not found", 404);
    return banner;
  }
}