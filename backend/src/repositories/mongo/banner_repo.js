import Banner from "../../models/banner_model.js";
import IBannerRepository from "../interfaces/i_banner_repo.js";
export default class BannerRepositoryMongo extends IBannerRepository  {
  async create(data) {
    return Banner.create(data);
  }

  async findById(bannerId) {
    return Banner.findOne({ bannerId, deleted: false });
  }

  async find(filter = {}, options = {}) {
    const { skip = 0, limit = 10, sort = { createdAt: -1 } } = options;
    return Banner.find({ ...filter, deleted: false })
      .skip(skip)
      .limit(limit)
      .sort(sort);
  }

  async update(bannerId, data) {
    return Banner.findOneAndUpdate({ bannerId }, data, { new: true });
  }

  async delete(bannerId) {
    return Banner.findOneAndUpdate({ bannerId }, { deleted: true }, { new: true });
  }
}
