const User = require("../../models/user_model");

const GetAllUsers = async (req, res) => {
  try {
    const users = await User.find({ role: { $ne: "admin" } }).select(
      "-passwordHash -otp -otpExpires -refreshToken"
    );
    res.json({ users });
  } catch (err) {
    console.error("Get all users error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
const GetUsersWithUnapprovedLicenses = async (req, res) => {
  try {
    const users = await User.find({
      "license.approved": false,
      role: { $ne: "admin" },
    }).select("-passwordHash -otp -otpExpires -refreshToken");

    res.json({ users });
  } catch (err) {
    console.error("Get users with unapproved licenses error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
const ApproveLicense = async (req, res) => {
  const { userId, licenseId } = req.body;

  try {
    const user = await User.findOne({ userId });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const license = user.license.find((l) => l.licenseId === licenseId);

    if (!license) {
      return res.status(404).json({ message: "License not found" });
    }

    license.approved = true;

    await user.save();

    res.json({ message: "License approved successfully" });
  } catch (err) {
    console.error("Approve license error:", err.message);
    res.status(500).json({ message: "Internal server error" });
  }
};

const RejectLicense = async (req, res) => {
  const { userId, licenseId } = req.body;

  try {
    const user = await User.findOne({ userId });
    if (!user) return res.status(404).json({ message: "User not found" });

    const license = user.license.find((l) => l.licenseId === licenseId);
    if (!license) return res.status(404).json({ message: "License not found" });

    license.approved = false;
    await user.save();

    res.json({ message: "License rejected successfully" });
  } catch (err) {
    console.error("Reject license error:", err.message);
    res.status(500).json({ message: "Internal server error" });
  }
};
const GetUser = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findOne({
      _id: id,
      role: { $ne: "admin" },
    }).select("-passwordHash -otp -otpExpires -refreshToken");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ user });
  } catch (err) {
    console.error("Get user by ID error:", err.message);
    res.status(500).json({ message: "Internal server error" });
  }
};
const DeleteAccount = async (req, res) => {
    try {
      const user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
  
      await User.deleteOne({ _id: user._id });
      res.json({ message: "Account deleted successfully" });
    } catch (err) {
      console.error("Delete account error:", err.message);
      res.status(400).json({ message: err.message });
    }
  };
module.exports = {
  DeleteAccount,
  GetAllUsers,
  GetUsersWithUnapprovedLicenses,
  ApproveLicense,
  RejectLicense,
  GetUser,
};
