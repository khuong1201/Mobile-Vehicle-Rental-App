export default class TelemetryActiveService {
  constructor(TelemetryActiveRepo, validator) {
    this.telemetryActiveRepo = TelemetryActiveRepo;
    this.validator = validator;
  }

  async getLatest(deviceId) {
    return this.telemetryActiveRepo.getLatestByDevice(deviceId);
  }

  async getRoute(deviceId, from, to) {
    return this.telemetryActiveRepo.getRoute(deviceId, from, to);
  }

  async getNearby(coords, radius) {
    return this.telemetryActiveRepo.getNearLocation(coords, radius);
  }
}
