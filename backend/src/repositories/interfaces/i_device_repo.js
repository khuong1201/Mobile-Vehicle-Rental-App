import IRepo from "./i_repo.js";

export default class IDeviceRepository extends IRepo{
    async findByDeviceId(deviceId){
        throw new Error("Not implemented.");
    }
}