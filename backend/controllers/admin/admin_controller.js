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
  if (!users.length) {
    return next(new AppError("No users found", 404, "USERS_NOT_FOUND"));
  }

  return res.success("Users fetched successfully", users, { total: users.length });
});

const getUsersWithUnapprovedLicenses = asyncHandler(async (req, res, next) => {
  const users = await User.find({
    role: { $ne: "admin" },
    license: { $exists: true, $ne: [] }
  }).select("fullName email license avatar");

  const filteredUsers = users
    .map((user) => {
      const pending = user.license.filter((l) => l.status === "pending");
      return pending.length
        ? {
            _id: user._id,
            fullName: user.fullName,
            email: user.email,
            avatar: user.avatar,
            license: pending.map((l) => ({
              _id: l._id,
              status: l.status,
              driverLicenseFront: l.driverLicenseFront,
              driverLicenseBack: l.driverLicenseBack
            }))
          }
        : null;
    })
    .filter(Boolean);

  if (!filteredUsers.length) {
    return next(
      new AppError("No users with unapproved licenses found", 404, "LICENSES_NOT_FOUND")
    );
  }

  return res.success(
    "Users with unapproved licenses fetched successfully",
    filteredUsers,
    { total: filteredUsers.length }
  );
});

const approveLicense = asyncHandler(async (req, res, next) => {
  const { userId, licenseId } = req.body;

  const user = await findUserOrFail(userId);
  const license = user.license.id(licenseId);
  if (!license) {
    return next(new AppError("License not found", 404, "LICENSE_NOT_FOUND"));
  }

  license.status = "approved";
  await user.save();

  return res.success("License approved successfully", { userId, licenseId });
});

const rejectLicense = asyncHandler(async (req, res, next) => {
  const { userId, licenseId } = req.body;

  const user = await findUserOrFail(userId);
  const license = user.license.id(licenseId);
  if (!license) {
    return next(new AppError("License not found", 404, "LICENSE_NOT_FOUND"));
  }

  license.status = "rejected";
  await user.save();

  return res.success("License rejected successfully", { userId, licenseId });
});

const getUser = asyncHandler(async (req, res, next) => {
  const user = await User.findOne({
    _id: req.params.id,
    role: { $ne: "admin" }
  }).select(EXCLUDE_FIELDS);

  if (!user) {
    return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  }

  return res.success("User fetched successfully", user);
});

const deleteAccount = asyncHandler(async (req, res, next) => {
  const user = await findUserOrFail(req.user.id);
  await user.deleteOne();

  return res.success("Account deleted successfully");
});

const getTotalUsers = asyncHandler(async (req, res) => {
  const totalUsers = await User.countDocuments({ role: { $ne: "admin" } });
  return res.success("Total users fetched successfully", { totalUsers });
});

module.exports = {
  getAllUsers,
  getUsersWithUnapprovedLicenses,
  approveLicense,
  rejectLicense,
  getUser,
  deleteAccount,
  getTotalUsers
};
