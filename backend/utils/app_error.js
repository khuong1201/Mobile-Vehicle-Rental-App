class AppError extends Error {
  constructor(message, statusCode, errorCode) {
    super(message);
    this.statusCode = statusCode || 500;
    this.errorCode = errorCode || 'INTERNAL_ERROR';
    Error.captureStackTrace(this, this.constructor);
  }
}

module.exports = AppError;
