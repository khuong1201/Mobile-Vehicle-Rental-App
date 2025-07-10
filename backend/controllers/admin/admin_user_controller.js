const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");
const GetAllUsers = async (req, res, next) => {
  try {
    const users = await User.find({ role: { $ne: "admin" } }).select(
      "-passwordHash -otp -otpExpires -refreshToken"
    );
    if( !users || users.length === 0) return next(new AppError("No users found", 404, "USERS_NOT_FOUND"));
    res.json({ users });
  } catch (err) {
    console.error("Get all users error:", err.message);
    next(err);
  }
};
const GetUsersWithUnapprovedLicenses = async (req, res, next) => {
  try {
    const users = await User.find({
      role: { $ne: "admin" },
      license: { $exists: true, $ne: [] }
    }).select("fullName email license avatar");

    const filteredUsers = users
      .map(user => {
        const pendingLicenses = user.license.filter(l => l.status === 'pending');
        if (pendingLicenses.length === 0) return null;

        return {
          _id: user._id,
          fullName: user.fullName,
          email: user.email,
          avatar: user.avatar,
          license: pendingLicenses.map(l => ({
            _id: l._id,
            status: l.status,
            driverLicenseFront: l.driverLicenseFront,
            driverLicenseBack: l.driverLicenseBack,
          }))
        };
      })
      .filter(Boolean); 

    res.json({ users: filteredUsers });
  } catch (err) {
    console.error("Get users with unapproved licenses error:", err.message);
    next(err);
  }
};

const ApproveLicense = async (req, res, next) => {
  const { userId, licenseId } = req.body;

  try {
    const user = await User.findById( userId );

    if (!user) return next(new AppError("User not found", 404, "USER_NOT_FOUND"));

    const license = user.license.find((l) => l._id.toString() === licenseId);

    if (!license) return next(new AppError("License not found", 404, "LICENSE_NOT_FOUND"));

    license.status = 'approved';

    await user.save();

    res.json({ message: "License approved successfully" });
  } catch (err) {
    console.error("Approve license error:", err.message);
    next(err);
  }
};

const RejectLicense = async (req, res, next) => {
  const { userId, licenseId } = req.body;

  try {
    const user = await User.findById( userId );
    if (!user) return next(new AppError("User not found", 404, "USER_NOT_FOUND"));

    const license = user.license.find((l) => l._id.toString() === licenseId);
    if (!license) return next(new AppError("License not found", 404, "LICENSE_NOT_FOUND"));

    license.status = 'rejected';
    await user.save();

    res.json({ message: "License rejected successfully" });
  } catch (err) {
    console.error("Reject license error:", err.message);
    next(err);
  }
};
const GetUser = async (req, res, next) => {
  const { id } = req.params;

  try {
    const user = await User.findOne({
      _id: id,
      role: { $ne: "admin" },
    }).select("-passwordHash -otp -otpExpires -refreshToken");

    if (!user) return next(new AppError("User not found", 404, "USER_NOT_FOUND"));

    res.json({ user });
  } catch (err) {
    console.error("Get user by ID error:", err.message);
    next(err);
  }
};
const GetAdminProfile = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).select(
      "-passwordHash -otp -otpExpires -refreshToken"
    );
    if (!user) return next(new AppError("User not found", 404, "USER_NOT_FOUND"));

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
        points: user.points,
      },
    });
  } catch (err) {
    console.error("Get user profile error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
const DeleteAccount = async (req, res, next) => {
    try {
      const user = await User.findById(req.user.id);
      if (!user) return next(new AppError("User not found", 404, "USER_NOT_FOUND"));
  
      await User.deleteOne({ _id: user._id });
      res.json({ message: "Account deleted successfully" });
    } catch (err) {
      console.error("Delete account error:", err.message);
      next(err);
    }
  };

  const GetTotalUsers = async (req, res, next) => {
    try {
      const totalUsers = await User.countDocuments({ role: { $ne: "admin" } });
      res.json({ totalUsers });
    } catch (err) {
      console.error("Get total users error:", err.message);
      next(err);
    }
  };
module.exports = {
  GetTotalUsers,
  DeleteAccount,
  GetAllUsers,
  GetUsersWithUnapprovedLicenses,
  ApproveLicense,
  RejectLicense,
  GetUser,
  GetAdminProfile,
};
