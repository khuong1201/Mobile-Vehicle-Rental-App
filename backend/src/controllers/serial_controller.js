import asyncHandler from "../middlewares/async_handler.js";

class SerialController {
  constructor(serialService) {
    this.serialService = serialService;
    this.control = asyncHandler(this.control.bind(this));
  }

  async control(req, res) {
    const { imei, action } = req.body;

    if (!imei) {
      return res.status(400).json({ message: "Missing imei" });
    }

    if (!["ON", "OFF"].includes(action)) {
      return res.status(400).json({ message: "Invalid action" });
    }

    const result = await this.serialService.sendCommandToDevice(imei, action);

    return res.json({
      success: true,
      ...result, 
    });
  }
}

export default SerialController;
