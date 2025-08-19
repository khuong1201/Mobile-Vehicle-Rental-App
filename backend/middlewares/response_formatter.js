const { v4: uuidv4 } = require("uuid");

function responseFormatter(req, res, next) {
  res.success = (message = "Success", data = {}, meta = {}) => {
    return res.json({
      success: true,
      message,
      data,
      meta,
      timestamp: new Date().toISOString(),
      requestId: req.id || uuidv4(),
    });
  };

  res.error = (message = "Error", statusCode = 400, data = null, meta = {}) => {
    return res.status(statusCode).json({
      success: false,
      message,
      data,
      meta,
      timestamp: new Date().toISOString(),
      requestId: req.id || uuidv4(),
    });
  };

  next();
}

module.exports = responseFormatter;
