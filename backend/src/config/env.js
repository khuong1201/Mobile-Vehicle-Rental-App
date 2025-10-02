import 'dotenv/config';

const FIREBASE_SERVICE_ACCOUNT = {
  type: process.env.FIREBASE_TYPE,
  project_id: process.env.FIREBASE_PROJECT_ID,
  private_key: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
  client_email: process.env.FIREBASE_CLIENT_EMAIL,
  client_id: process.env.FIREBASE_CLIENT_ID,
  auth_uri: process.env.FIREBASE_AUTH_URI,
  token_uri: process.env.FIREBASE_TOKEN_URI,
  auth_provider_x509_cert_url: process.env.FIREBASE_AUTH_PROVIDER_X509_CERT_URL,
  client_x509_cert_url: process.env.FIREBASE_CLIENT_X509_CERT_URL,
  universe_domain: process.env.FIREBASE_UNIVERSE_DOMAIN,
};

const env = {
    NODE_ENV: process.env.NODE_ENV || "development",
    PORT: parseInt(process.env.PORT || "5000", 10),
    DB_DRIVER: process.env.DB_DRIVER || "mongo", // "mongo" | "mysql"
    MONGO_URI: process.env.MONGO_URI || "mongodb://localhost:27017/vehiclerental",
    MYSQL_URI: process.env.MYSQL_URI || "mysql://user:pass@localhost:3306/vehiclerental",
    REDIS_URL: process.env.REDIS_URL || "redis://localhost:6379",
    JWT_SECRET: process.env.JWT_SECRET || "dev_secret",
    JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET || "dev_refresh",
    ACCESS_TOKEN_EXPIRES: process.env.ACCESS_TOKEN_EXPIRES || "15m",
    REFRESH_TOKEN_EXPIRES: process.env.REFRESH_TOKEN_EXPIRES || "7d",
    OTP_SECRET: process.env.OTP_SECRET || "otp_dev_secret",
    CORS_ORIGIN: process.env.CORS_ORIGIN || "*",
    EMAL_USER: process.env.EMAL_USER || 'example@gmail.com',
    EMAIL_PASS: process.env.EMAIL_PASS || 'yourpassword',
    CLOUDINARY_CLOUD_NAME: process.env.CLOUDINARY_CLOUD_NAME || 'yourcloudname',
    CLOUDINARY_API_KEY: process.env.CLOUDINARY_API_KEY || 'yourapikey',
    CLOUDINARY_API_SECRET: process.env.CLOUDINARY_API_SECRET || 'yourapisecret',
    GOOGLE_CLIENT_ID: process.env.GOOGLE_CLIENT_ID || 'yourgoogleclientid',
    GOOGLE_CLIENT_SECRET: process.env.GOOGLE_CLIENT_SECRET || 'yourgoogleclientsecret',
    GOOGLE_API_KEY: process.env.GOOGLE_API_KEY || 'yourgoogleapikey',
    CALLBACK_URL: process.env.CALLBACK_URL || 'http://localhost:5000/api/auth/google/callback',
    SESSION_SECRET: process.env.SESSION_SECRET || 'yoursessionsecret',
    MOMO_PARTNER_CODE: process.env.MOMO_PARTNER_CODE || 'yourpartnercode',
    MOMO_ACCESS_KEY: process.env.MOMO_ACCESS_KEY || 'youraccesskey',
    MOMO_SECRET_KEY: process.env.MOMO_SECRET_KEY || 'yoursecretkey',
    MOMO_REDIRECT_URL: process.env.MOMO_REDIRECT_URL || 'http://localhost:5000/api/payments/momo/callback',
    MOMO_IPN_URL: process.env.MOMO_IPN_URL || 'http://localhost:5000/api/payments/momo/ipn',
    DEVICE_TOKEN_SECRET: process.env.DEVICE_TOKEN_SECRET || 'dev_secret',
    DEVICE_TOKEN_EXPIRES: process.env.DEVICE_TOKEN_EXPIRES || '1y',
    FIREBASE_SERVICE_ACCOUNT,
};

export default env;