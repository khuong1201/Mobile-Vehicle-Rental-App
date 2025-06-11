const bcrypt = require("bcrypt");
const User = require("../../models/user_model");

// Change Password
const changePassword = async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    if (!oldPassword || !newPassword) {
      return res
        .status(400)
        .json({ message: "oldPassword and newPassword are required" });
    }
    if (newPassword.length < 8) {
      return res
        .status(400)
        .json({ message: "New password must be at least 8 characters" });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.passwordHash) {
      return res
        .status(400)
        .json({ message: "Use Google login or reset password" });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.passwordHash);
    if (!isMatch) {
      return res.status(400).json({ message: "Incorrect old password" });
    }

    const passwordHash = await bcrypt.hash(newPassword, 10);
    user.passwordHash = passwordHash;
    await user.save();

    res.json({ message: "Password changed successfully" });
  } catch (err) {
    console.error("Change password error:", err.message);
    res.status(400).json({ message: err.message });
  }
};

// Delete Account
const deleteAccount = async (req, res) => {
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

const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select(
      "-passwordHash -otp -otpExpires -refreshToken"
    );
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

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
        address: user.address,
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

// Delete Driver's License by _id

module.exports = {
  changePassword,
  deleteAccount,
  getUserProfile,
};
