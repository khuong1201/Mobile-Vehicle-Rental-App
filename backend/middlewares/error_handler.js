const { v4: uuidv4 } = require("uuid");
module.exports = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const errorCode = err.errorCode || "INTERNAL_ERROR";
  const message = err.message || "Something went wrong";

  if (process.env.NODE_ENV === "development") {
    console.error("🔥 Error:", err);
  }

  return res.status(statusCode).json({
    success: false,
    message,
    errorCode,
    data: null,
    meta: {},
    timestamp: new Date().toISOString(),
    requestId: req.id || uuidv4(),
  });
};