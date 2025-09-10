import asyncHandler from "../middlewares/async_handler.js";

export default class AuthController {
  constructor(userAuthService) {
    this.service = userAuthService;

    this.register = asyncHandler(this.register.bind(this));
    this.verifyOtp = asyncHandler(this.verifyOtp.bind(this));
    this.login = asyncHandler(this.login.bind(this));
    this.googleLogin = asyncHandler(this.googleLogin.bind(this));
    this.logout = asyncHandler(this.logout.bind(this));
    this.refeshToken = asyncHandler(this.refeshToken.bind(this));
  }

  async register(req, res) {
    const data = await this.service.register(req.body);
    res.json({ status: "success", data });
  }

  async verifyOtp(req, res) {
    const { email, otp } = req.body;
    const data = await this.service.verifyOtp(email, otp);
    res.json({ status: "success", data });
  }

  async login(req, res) {
    const { email, password } = req.body;
    const data = await this.service.login(email, password);
    res.json({ status: "success", data });
  }

  async googleLogin(req, res) {
    const { tokenId } = req.body;
    const data = await this.service.googleLogin(tokenId);
    res.json({ status: "success", data });
  }

  async logout(req, res) {
    const userId = req.user.userId;
    await this.service.logout(userId);
    res.json({ status: "success", message: "Logged out successfully" });
  }

  async refeshToken(req, res) {
    const { refreshToken } = req.body;
    const data = await this.service.refreshToken(refreshToken);
    res.json({ status: "success", data });
  }
}
