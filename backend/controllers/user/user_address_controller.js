const User = require("../../models/user_model");

const GetAddresses = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('addresses');
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({
      message: 'Addresses retrieved successfully',
      addresses: user.addresses || [], // Return empty array if no addresses
    });
  } catch (err) {
    console.error('Get addresses error:', err.message);
    res.status(400).json({ message: err.message });
  }
};

const DeleteAddress = async (req, res) => {
  try {
    const { addressId } = req.body;

    // Validate input
    if (!addressId) {
      return res.status(400).json({ message: "addressId is required" });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if address exists
    const addressExists = user.addresses.some(
      (addr) => addr._id.toString() === addressId
    );
    if (!addressExists) {
      return res.status(400).json({ message: "Address not found" });
    }

    // Remove the address
    user.addresses = user.addresses.filter(
      (addr) => addr._id.toString() !== addressId
    );
    await user.save();

    res.json({
      message: "Address deleted successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        addresses: user.addresses,
      },
    });
  } catch (err) {
    console.error("Delete address error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
const UpdateAddress = async (req, res) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: "Request body is missing" });
    }
    const {
      addressId,
      addressType,
      address,
      floorOrApartmentNumber,
      contactName,
      phoneNumber,
    } = req.body;
    if (!addressType) {
      return res.status(400).json({ message: "Address type is required" });
    } else if (!address) {
      return res.status(400).json({ message: "Address is required" });
    } else if (!floorOrApartmentNumber) {
      return res
        .status(400)
        .json({ message: "Floor or apartment number is required" });
    } else if (!contactName) {
      return res.status(400).json({ message: "Contact name is required" });
    } else if (!phoneNumber) {
      return res.status(400).json({ message: "Phone number is required" });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Ensure addresses array exists
    user.addresses = user.addresses || [];

    // New address object
    const newAddress = {
      addressType,
      address,
      floorOrApartmentNumber,
      contactName,
      phoneNumber,
    };

    if (addressId) {
      // Update existing address
      const addressIndex = user.addresses.findIndex(
        (addr) => addr._id.toString() === addressId
      );
      if (addressIndex === -1) {
        return res.status(400).json({ message: "Address not found" });
      }
      user.addresses[addressIndex] = {
        ...user.addresses[addressIndex],
        ...newAddress,
      };
    } else {
      // Add new address
      user.addresses.push(newAddress);
    }

    await user.save();

    res.json({
      message: "Address updated successfully",
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        addresses: user.addresses,
      },
    });
  } catch (err) {
    console.error("Update address error:", err.message);
    res.status(400).json({ message: err.message });
  }
};
module.exports = { DeleteAddress, UpdateAddress, GetAddresses };
