const bcrypt = require("bcrypt");
const User = require("../../models/user_model");

const ChangePassword = async (req, res) => {
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
module.exports = {
  ChangePassword,
};
