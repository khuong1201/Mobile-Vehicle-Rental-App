import jwt from 'jsonwebtoken';
import env from '../config/env.js';
import AppError from '../utils/app_error.js';
import asyncHandler from './async_handler.js';

const authenticateJWT = asyncHandler(async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new AppError('Authorization header missing or malformed', 401);
  }

  const token = authHeader.split(' ')[1];
  let decoded;
  try {
    decoded = jwt.verify(token, env.JWT_SECRET);
  } catch (err) {
    throw new AppError('Invalid or expired token', 401);
  }

  req.user = decoded;
  next();
});

export default authenticateJWT;