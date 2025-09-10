import IRepository from "./i_repo.js";

class IBrandRepository extends IRepository {
  async findByName(name) {
    throw new Error("Not implemented.");
  }
}

export default IBrandRepository;