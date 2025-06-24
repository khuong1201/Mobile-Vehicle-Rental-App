const User = require('../../models/user_model'); 

const UpdateUserRole = async (req, res) => {
  try {
    const { userId, newRole } = req.body;

    if (!userId || !newRole) {
      return res.status(400).json({ message: "User ID and new role are required" });
    }

    const allowedRoles = ['renter', 'owner', 'admin'];
    if (!allowedRoles.includes(newRole)) {
      return res.status(400).json({ message: "Invalid role" });
    }

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    const isSelf = req.user._id.toString() === user._id.toString();
    const isAdmin = req.user.role === 'admin';

    // ❌ Không ai được chuyển sang admin trừ admin
    if (newRole === 'admin' && !isAdmin) {
      return res.status(403).json({ message: "Only admin can assign 'admin' role" });
    }

    // ❌ Không ai được đổi role người khác, trừ admin
    if (!isSelf && !isAdmin) {
      return res.status(403).json({ message: "You can only change your own role" });
    }

    // ❌ Người thường chỉ được đổi sang 'owner'
    if (!isAdmin && newRole !== 'owner') {
      return res.status(403).json({ message: "You are only allowed to change your role to 'owner'" });
    }

    user.role = newRole;
    await user.save();

    res.json({
      message: "User role updated successfully",
      updatedUser: {
        id: user._id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
      }
    });
  } catch (err) {
    console.error("Update role error:", err.message);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = {UpdateUserRole};