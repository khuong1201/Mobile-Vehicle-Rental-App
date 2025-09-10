import TelemetryActive from "../../models/telemetry_active_model.js";
import ITelemetryActiveRepository from '../interfaces/i_telemetry_active_repo.js'

export default class TelemetryActiveRepositoryMongo extends ITelemetryActiveRepository {
  async create(data) { return TelemetryActive.create(data); }
  async findById(id) { return TelemetryActive.findById(id); }
  async find(filter, options) { return TelemetryActive.find(filter, null, options); }
  async update(id, data) { return TelemetryActive.findByIdAndUpdate(id, data, { new: true }); }
  async delete(id) { return TelemetryActive.findByIdAndDelete(id); }

  async getLatestByDevice(deviceId) {
    return TelemetryActive.findOne({ deviceId }).sort({ ts: -1 });
  }

  async getRoute(deviceId, from, to) {
    return TelemetryActive.find({
      deviceId,
      ts: { $gte: from, $lte: to }
    }).sort({ ts: 1 });
  }

  async getNearLocation(coords, radiusMeters) {
    return TelemetryActive.find({
      location: {
        $near: {
          $geometry: { type: "Point", coordinates: coords },
          $maxDistance: radiusMeters
        }
      }
    });
  }
}
