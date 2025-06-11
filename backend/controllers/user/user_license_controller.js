const User = require("../../models/user_model");

const getDriverLicenses = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("license");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({
      message: "Driver licenses retrieved successfully",
      licenses: user.license || [], // Return empty array if no licenses
    });
  } catch (err) {
    console.error("Get driver licenses error:", err.message);
    res.status(400).json({ message: err.message });
  }
};

const updateDriverLicense = async (req, res) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: "Request body is missing" });
    }

    const {
      licenseId,
      typeOfDriverLicense,
      classLicense,
      licenseNumber,
      driverLicenseFront,
      driverLicenseBack,
    } = req.body;

    if (!typeOfDriverLicense) {
      return res
        .status(400)
        .json({ message: "Type of driver license is required" });
    } else if (!classLicense) {
      return res.status(400).json({ message: "Class is required" });
    } else if (!licenseNumber) {
      return res.status(400).json({ message: "License number is required" });
    } else if (!driverLicenseFront) {
      return res
        .status(400)
        .json({ message: "Front view picture is required" });
    } else if (!driverLicenseBack) {
      return res.status(400).json({ message: "Back view picture is required" });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Ensure license array exists
    user.license = user.license || [];

    // New license object
    const newLicense = {
      typeOfDriverLicense,
      classLicense,
      licenseNumber,
      driverLicenseFront,
      driverLicenseBack,
      approved: false,
    };

    if (licenseId) {
      // Update existing license
      const licenseIndex = user.license.findIndex(
        (lic) => lic._id.toString() === licenseId
      );
      if (licenseIndex === -1) {
        return res.status(400).json({ message: "License not found" });
      }
      user.license[licenseIndex] = {
        ...user.license[licenseIndex],
        ...newLicense,
      };
    } else {
      // Add new license
      user.license.push(newLicense);
    }

    await user.save();

    res.json({
      message: "Driver license updated successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        license: user.license,
      },
    });
  } catch (err) {
    console.error("Update driver license error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
const deleteDriverLicense = async (req, res) => {
  try {
    const { licenseId } = req.body;

    // Validate input
    if (!licenseId) {
      return res.status(400).json({ message: "licenseId is required" });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if license exists
    const licenseExists = user.license.some(
      (lic) => lic._id.toString() === licenseId
    );
    if (!licenseExists) {
      return res.status(400).json({ message: "License not found" });
    }

    // Remove the license
    user.license = user.license.filter(
      (lic) => lic._id.toString() !== licenseId
    );
    await user.save();

    res.json({
      message: "Driver license deleted successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        license: user.license,
      },
    });
  } catch (err) {
    console.error("Delete driver license error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
module.exports = { updateDriverLicense, deleteDriverLicense, getDriverLicenses };
