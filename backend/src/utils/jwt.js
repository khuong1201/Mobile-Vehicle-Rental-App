import jwt from "jsonwebtoken";
import env from "../config/env.js";

export function generateAccessToken(user) {
    return jwt.sign(
        { userId: user.userId, role: user.role },
        env.JWT_SECRET,
        { expiresIn: env.ACCESS_TOKEN_EXPIRES }
    );
}

export function generateRefreshToken(user) {
    return jwt.sign(
        { userId: user.userId, role: user.role },
        env.JWT_REFRESH_SECRET,
        { expiresIn: env.REFRESH_TOKEN_EXPIRES }
    );
}

export function generateDeviceToken(device) {
    return jwt.sign(
        { deviceId: device.deviceId },
        env.DEVICE_TOKEN_SECRET,
        { expiresIn: env.DEVICE_TOKEN_EXPIRES }
    )
}
export function isTokenExpired(token, secret = env.DEVICE_TOKEN_SECRET) {
    try {
        jwt.verify(token, secret);
        return false;
    } catch (err) {
        if (err.name === "TokenExpiredError") {
            return true; 
        }
        throw err;
    }
}
