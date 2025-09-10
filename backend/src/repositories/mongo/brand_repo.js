import Brand from "../../models/brand_model.js";
import IBrandRepository from "../interfaces/i_brand_repo.js";

class BrandRepositoryMongo extends IBrandRepository {
  async create(data) {
    return await Brand.create(data);
  }

  async findById(id) {
    return await Brand.findOne({ brandId: id });
  }

  async findAll(filter = {}) {
    return await Brand.find(filter);
  }

  async update(id, updateData) {
    return await Brand.findOneAndUpdate(
      { brandId: id },
      updateData,
      { new: true }
    );
  }

  async delete(id) {
    return await Brand.findOneAndDelete({ brandId: id });
  }

  async findByName(name) {
    return await Brand.findOne({ brandName: name });
  }
}

export default BrandRepositoryMongo;
