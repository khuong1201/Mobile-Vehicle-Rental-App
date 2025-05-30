const bcrypt = require('bcrypt');
const User = require('../../models/user_model');

// Change Password
const changePassword = async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    if (!oldPassword || !newPassword) {
      return res.status(400).json({ message: 'oldPassword and newPassword are required' });
    }
    if (newPassword.length < 8) {
      return res.status(400).json({ message: 'New password must be at least 8 characters' });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (!user.passwordHash) {
      return res.status(400).json({ message: 'Use Google login or reset password' });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.passwordHash);
    if (!isMatch) {
      return res.status(400).json({ message: 'Incorrect old password' });
    }

    const passwordHash = await bcrypt.hash(newPassword, 10);
    user.passwordHash = passwordHash;
    await user.save();

    res.json({ message: 'Password changed successfully' });
  } catch (err) {
    console.error('Change password error:', err.message);
    res.status(400).json({ message: err.message });
  }
};

// Delete Account
const deleteAccount = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    await User.deleteOne({ _id: user._id });
    res.json({ message: 'Account deleted successfully' });
  } catch (err) {
    console.error('Delete account error:', err.message);
    res.status(400).json({ message: err.message });
  }
};

// Update User Details
const updateDetails = async (req, res) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: 'Request body is missing' });
    }

    const { fullName, role, license } = req.body;

    // Validate inputs
    if (!fullName && !role && !license) {
      return res.status(400).json({ message: 'At least one field (fullName, role, license) is required' });
    }

    if (role && !['renter', 'owner'].includes(role)) {
      return res.status(400).json({ message: 'Role must be either "renter" or "owner"' });
    }

    if (license) {
      if (typeof license !== 'object' || license === null) {
        return res.status(400).json({ message: 'License must be an object' });
      }
      const { number, imageUrl, approved } = license;
      if (number && typeof number !== 'string') {
        return res.status(400).json({ message: 'License number must be a string' });
      }
      if (imageUrl && typeof imageUrl !== 'string') {
        return res.status(400).json({ message: 'License imageUrl must be a string' });
      }
      if (approved !== undefined && typeof approved !== 'boolean') {
        return res.status(400).json({ message: 'License approved must be a boolean' });
      }
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Update provided fields
    if (fullName) user.fullName = fullName;
    if (role) user.role = role;
    if (license) {
      user.license = {
        number: license.number || user.license?.number,
        imageUrl: license.imageUrl || user.license?.imageUrl,
        approved: license.approved !== undefined ? license.approved : user.license?.approved
      };
    }

    await user.save();

    res.json({
      message: 'User details updated successfully',
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        role: user.role,
        fullName: user.fullName,
        license: user.license
      }
    });
  } catch (err) {
    console.error('Update details error:', err.message);
    res.status(400).json({ message: err.message });
  }
};

module.exports = { changePassword, deleteAccount, updateDetails };