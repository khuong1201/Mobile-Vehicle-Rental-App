import asyncHandler from "../middlewares/async_handler.js";

export default class OtpController {
  constructor(OtpService) {
    this.otpService = OtpService;;

    this.createOtp = asyncHandler(this.createOtp.bind(this));
    this.verifyOtp = asyncHandler(this.verifyOtp.bind(this));
  }

  async createOtp(req, res) {
    const { identifier, code } = req.body;
    const data = await this.otpService.createOtp(identifier, code);
    res.json({ status: "success", data });
  }

  async verifyOtp(req, res) {
    const { identifier, code } = req.body;
    const data = await this.otpService.verifyOtp(identifier, code);
    res.json({ status: "success", data });
  }
}