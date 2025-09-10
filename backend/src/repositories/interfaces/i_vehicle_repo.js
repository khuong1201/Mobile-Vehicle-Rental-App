import IRepo from "./i_repo.js";

export default class IVehicleRepo extends IRepo {
    async findByType(type) { throw new Error("Not implemented"); }
    async findUnavailable() { throw new Error("Not implemented"); }
    async createByType(type, data) { throw new Error("Not implemented"); }
}