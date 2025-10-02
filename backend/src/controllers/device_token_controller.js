import asyncHandler from "../middlewares/async_handler.js";

export default class DeviceController {
  constructor(deviceService) {
    this.service = deviceService;

    this.register = asyncHandler(this.register.bind(this));
    this.remove = asyncHandler(this.remove.bind(this));
  }

  async register(req, res) {
    const { token, platform, deviceId } = req.body;
    const userId = req.user.userId;

    const data = await this.service.registerDeviceToken(
      userId,
      token,
      platform,
      deviceId
    );
    res.json({ status: "success", data });
  }

  async remove(req, res) {
    const { token } = req.body;
    const userId = req.user.userId;

    const data = await this.service.removeDeviceToken(userId, token);
    res.json({ status: "success", data });
  }
}
