import DeviceModel from '../../models/device_model.js';
import IDeviceRepository from '../interfaces/i_device_repo.js';

export default class DeviceRepositoryMongo extends IDeviceRepository {
    async create(data) {
        return DeviceModel.create(data);
    }

    async findById(id) {
        return DeviceModel.findOne({ _id: id, deleted: false });
    }
    
    async find(filter = {}, options = {}) {
        return DeviceModel.find(
            {...filter, deleted: false}, null, options
        );
    }

    async findByDeviceId(deviceId) {
        return DeviceModel.findOne({ deviceId, deleted: false })
    }

    async findByImei(imei){
        return DeviceModel.findOne({ imei: imei, deleted: false})
    }

    async update(id, data) {
        return DeviceModel.findOneAndUpdate(
            { deviceId: id },
            { ...data },
            { new: true }
        );
    }

    async updateByImei(imei, data) {
        return DeviceModel.findOneAndUpdate(
            { imei, deleted: false },
            { ...data },
            { new: true }
        );
    }
    

    async delete(id) {
        return DeviceModel.findOneAndUpdate(
            { deviceId: id },
            { deleted: true },
            { new: true }
        )
    }
}