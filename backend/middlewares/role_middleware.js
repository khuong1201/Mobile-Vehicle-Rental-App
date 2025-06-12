module.exports = async function OwnerMiddleware(req, res, next) {
  try {
    if (req.user?.role !== "owner") {
      return res
        .status(403)
        .json({ message: "Access denied. Owner role required." });
    }
    next();
  } catch (err) {
    console.error("Owner middleware error:", err.message);
    res.status(500).json({ message: "Internal server error" });
  }
};
