import asyncHandler from '../middlewares/async_handler.js';

export default class UserController {
  constructor(userService) {
    this.userService = userService;

    this.getProfile = asyncHandler(this.getProfile.bind(this));
    this.updatePassword = asyncHandler(this.updatePassword.bind(this));
    this.updateProfile = asyncHandler(this.updateProfile.bind(this));
    this.updateRole = asyncHandler(this.updateRole.bind(this));
    this.addLicense = asyncHandler(this.addLicense.bind(this));
    this.updateLicense = asyncHandler(this.updateLicense.bind(this));
    this.deleteLicense = asyncHandler(this.deleteLicense.bind(this));
    this.addAddress = asyncHandler(this.addAddress.bind(this));
    this.updateAddress = asyncHandler(this.updateAddress.bind(this));
    this.deleteAddress = asyncHandler(this.deleteAddress.bind(this));
  }

  async updatePassword(req, res) {
    const user = await this.userService.updatePassword(req.user.userId, req.body.newPassword);
    res.json({ status: 'success', data: user });
  }
  
  async getProfile(req, res) {
    const userId = req.user.userId; 
    const profile = await this.userService.getProfile(userId);
    res.json({ status: "success", data: profile });
  }

  async updateProfile(req, res) {
    const user = await this.userService.updateProfile(req.user.userId, req.body);
    res.json({ status: 'success', data: user });
  }

  async updateRole(req, res) {
    const user = await this.userService.updateRole(req.params.userId, req.body.role);
    res.json({ status: 'success', data: user });
  }

  async addLicense(req, res) {
    const licenses = await this.userService.addLicense(req.params.userId, req.body);
    res.json({ status: 'success', data: licenses });
  }

  async updateLicense(req, res) {
    const licenses = await this.userService.updateLicense(
      req.params.userId,
      req.params.licenseId,
      req.body
    );
    res.json({ status: 'success', data: licenses });
  }

  async deleteLicense(req, res) {
    const licenses = await this.userService.deleteLicense(
      req.params.userId,
      req.params.licenseId
    );
    res.json({ status: 'success', data: licenses });
  }

  async addAddress(req, res) {
    const addresses = await this.userService.addAddress(req.params.userId, req.body);
    res.json({ status: 'success', data: addresses });
  }

  async updateAddress(req, res) {
    const addresses = await this.userService.updateAddress(
      req.params.userId,
      req.params.addressId,
      req.body
    );
    res.json({ status: 'success', data: addresses });
  }

  async deleteAddress(req, res) {
    const addresses = await this.userService.deleteAddress(
      req.params.userId,
      req.params.addressId
    );
    res.json({ status: 'success', data: addresses });
  }
}
