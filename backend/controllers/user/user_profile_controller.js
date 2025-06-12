const User = require("../../models/user_model");

const updatePersonalInfo = async (req, res) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: "Request body is missing" });
    }
    const { fullName, dateOfBirth, phoneNumber, gender, IDs } = req.body;
    if (!fullName) {
      return res.status(400).json({ message: "Full name is required" });
    } else if (fullName.length < 3) {
      return res
        .status(400)
        .json({ message: "Full name must be at least 3 characters long" });
    } else if (!dateOfBirth) {
      return res.status(400).json({ message: "Date of birth is required" });
    } else if (!phoneNumber) {
      return res.status(400).json({ message: "Phone number is required" });
    } else if (phoneNumber.length < 10 || phoneNumber.length > 15) {
      return res
        .status(400)
        .json({
          message: "Phone number must be between 10 and 15 characters long",
        });
    } else if (!gender) {
      return res.status(400).json({ message: "gener is required" });
    } else if (!IDs || IDs.length === 0) {
      return res.status(400).json({ message: "At least one ID is required" });
    }
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    // Update personal info
    if (fullName) user.fullName = fullName;
    if (dateOfBirth) user.dateOfBirth = dateOfBirth;
    if (phoneNumber) user.phoneNumber = phoneNumber;
    if (IDs) user.IDs = IDs;
    await user.save();
    res.json({
      message: "User details updated successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        dateOfBirth: user.dateOfBirth,
        phoneNumber: user.phoneNumber,
        IDs: user.IDs,
      },
    });
  } catch (err) {
    console.error("Update personal info error:", err.message);
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
module.exports = {
  updatePersonalInfo,
  getUserProfile,
};
