import AppError from "../utils/app_error.js";

class BrandService {
  constructor(brandRepo, brandValidator, storage) {
    this.brandRepo = brandRepo;
    this.brandValidator = brandValidator;
    this.storage = storage;
  }

  async uploadLogo(file) {
    if (!file) return null;
    if (!file.mimetype?.startsWith("image/")) {
      throw new AppError("Brand logo file must be an image", 400);
    }
    const uploaded = await this.storage.upload(file, { folder: "brands" });
    return {
      url: uploaded.url,
      publicId: uploaded.publicId,
    };
  }

  async createBrand(payload, file) {
    this.brandValidator.validateCreate({ ...payload, file });

    const existing = await this.brandRepo.findByName(payload.brandName);
    if (existing) throw new AppError("Brand already exists", 400);

    const brandLogo = await this.uploadLogo(file);
    return await this.brandRepo.create({
      ...payload,
      brandLogo,
    });
  }

  async getBrandById(id) {
    this.brandValidator.validateId(id);
    return await this.brandRepo.findById(id);
  }

  async getAllBrands() {
    return await this.brandRepo.findAll();
  }

  async updateBrand(id, payload, file) {
    this.brandValidator.validateId(id);
    this.brandValidator.validateUpdate({ ...payload, file });

    const brandLogo = await this.uploadLogo(file);
    return await this.brandRepo.update(id, {
      ...payload,
      ...(brandLogo && { brandLogo }),
    });
  }

  async deleteBrand(id) {
    this.brandValidator.validateId(id);
    return await this.brandRepo.delete(id);
  }
}

export default BrandService;
