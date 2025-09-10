import IRepo from './i_repo.js';

export default class ITelemetryActiveRepository extends IRepo {
    async getLatestByDevice(deviceId) { throw new Error("Not implemented"); }
    async getRoute(deviceId, from, to) { throw new Error("Not implemented"); }
    async getNearLocation(coords, radiusMeters) { throw new Error("Not implemented"); }
  }