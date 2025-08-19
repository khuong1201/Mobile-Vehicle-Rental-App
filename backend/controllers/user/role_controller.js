const User = require("../../models/user_model");
const AppError = require("../../utils/app_error");
const asyncHandler = require("../../utils/async_handler");

const updateUserRole = asyncHandler(async (req, res, next) => {
  const { newRole } = req.body;
  const userId = req.user?.id || req.user?.userId;

  if (!userId || !newRole) {
    return next(new AppError("Lỗi khi gửi", 400, "MISSING_FIELDS"));
  }

  const allowedRoles = ["renter", "owner", "admin"];
  if (!allowedRoles.includes(newRole)) {
    return next(new AppError("Vai trò không hợp lệ", 400, "INVALID_ROLE"));
  }

  const user = await User.findById(userId);
  if (!user) {
    return next(new AppError("Không tìm thấy người dùng", 404, "USER_NOT_FOUND"));
  }

  const isSelf = req.user._id.toString() === user._id.toString();
  const isAdmin = req.user.role === "admin";

  if (newRole === "admin" && !isAdmin) {
    return next(
      new AppError("Chỉ admin mới có thể gán vai trò admin", 403, "FORBIDDEN_ADMIN_ASSIGNMENT")
    );
  }
  if (!isSelf && !isAdmin) {
    return next(
      new AppError("Bạn chỉ được thay đổi vai trò của chính mình", 403, "FORBIDDEN_SELF_ONLY")
    );
  }
  if (!isAdmin && newRole !== "owner") {
    return next(
      new AppError("Bạn chỉ được chuyển sang vai trò 'owner'", 403, "FORBIDDEN_ROLE_CHANGE")
    );
  }

  user.role = newRole;
  await user.save();

  return res.success("User role updated successfully", {
    id: user._id,
    email: user.email,
    fullName: user.fullName,
    role: user.role,
  });
});

module.exports = { updateUserRole };
