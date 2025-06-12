module.exports = async  function AdminMiddleware(req, res, next){
  try {
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized access" });
    }
    if (req.user.role !== "admin") {
      return res.status(403).json({ message: "Forbidden: Admins only" });
    }
    next();
  } catch (err) {
    console.error("Admin middleware error:", err.message);
    res.status(500).json({ message: "Internal server error" });
  }
};

