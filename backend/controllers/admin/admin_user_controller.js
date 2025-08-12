const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const EXCLUDE_FIELDS = "-passwordHash -otp -otpExpires -refreshToken";

const findUserOrFail = async (id) => {
  const user = await User.findById(id);
  if (!user) throw new AppError("User not found", 404, "USER_NOT_FOUND");
  return user;
};

const getAllUsers = asyncHandler(async (req, res, next) => {
  const users = await User.find({ role: { $ne: "admin" } }).select(EXCLUDE_FIELDS);
  if (!users.length) return next(new AppError("No users found", 404, "USERS_NOT_FOUND"));
  res.json({ users });
});

const getUsersWithUnapprovedLicenses = asyncHandler(async (req, res) => {
  const users = await User.find({
    role: { $ne: "admin" },
    license: { $exists: true, $ne: [] }
  }).select("fullName email license avatar");

  const filteredUsers = users
    .map(user => {
      const pending = user.license.filter(l => l.status === "pending");
      return pending.length
        ? {
            _id: user._id,
            fullName: user.fullName,
            email: user.email,
            avatar: user.avatar,
            license: pending.map(l => ({
              _id: l._id,
              status: l.status,
              driverLicenseFront: l.driverLicenseFront,
              driverLicenseBack: l.driverLicenseBack
            }))
          }
        : null;
    })
    .filter(Boolean);

  res.json({ users: filteredUsers });
});

const approveLicense = asyncHandler(async (req, res, next) => {
  const { userId, licenseId } = req.body;
  const user = await findUserOrFail(userId);
  const license = user.license.id(licenseId);
  if (!license) return next(new AppError("License not found", 404, "LICENSE_NOT_FOUND"));
  license.status = "approved";
  await user.save();
  res.json({ message: "License approved successfully" });
});

const rejectLicense = asyncHandler(async (req, res, next) => {
  const { userId, licenseId } = req.body;
  const user = await findUserOrFail(userId);
  const license = user.license.id(licenseId);
  if (!license) return next(new AppError("License not found", 404, "LICENSE_NOT_FOUND"));
  license.status = "rejected";
  await user.save();
  res.json({ message: "License rejected successfully" });
});

const getUser = asyncHandler(async (req, res, next) => {
  const user = await User.findOne({
    _id: req.params.id,
    role: { $ne: "admin" }
  }).select(EXCLUDE_FIELDS);
  if (!user) return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  res.json({ user });
});

const getAdminProfile = asyncHandler(async (req, res) => {
  const user = await findUserOrFail(req.user.id);
  res.json({
    message: "User profile retrieved successfully",
    user: {
      id: user._id,
      userId: user.userId,
      email: user.email,
      fullName: user.fullName,
      dateOfBirth: user.dateOfBirth,
      phoneNumber: user.phoneNumber,
      gender: user.gender,
      IDs: user.IDs,
      address: user.addresses,
      license: user.license,
      role: user.role,
      verified: user.verified,
      points: user.points
    }
  });
});

const deleteAccount = asyncHandler(async (req, res) => {
  const user = await findUserOrFail(req.user.id);
  await user.deleteOne();
  res.json({ message: "Account deleted successfully" });
});

const getTotalUsers = asyncHandler(async (req, res) => {
  const totalUsers = await User.countDocuments({ role: { $ne: "admin" } });
  res.json({ totalUsers });
});

module.exports = {
  getAllUsers,
  getUsersWithUnapprovedLicenses,
  approveLicense,
  rejectLicense,
  getUser,
  getAdminProfile,
  deleteAccount,
  getTotalUsers
};
