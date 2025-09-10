import { connect } from 'mongoose';
import env from './env.js';
import { Sequelize } from 'sequelize';

const { DB_DRIVER, MONGO_URI, MYSQL_URI } = env;

const connectDB = async () => {
  if (DB_DRIVER === 'mongo') {
    try {
      await connect(MONGO_URI);
      console.log('MongoDB connected');
    } catch (error) {
      console.error('MongoDB connection failed:', error);
      process.exit(1);
    }
  } else if (DB_DRIVER === 'mysql') {
    const sequelize = new Sequelize(MYSQL_URI);
    try {
      await sequelize.authenticate();
      console.log('MySQL connected');
      return sequelize;
    } catch (error) {
      console.error('MySQL connection failed:', error);
      process.exit(1);
    }
  } else {
    console.error('Invalid DB_DRIVER specified in environment variables.');
    process.exit(1);
  }
};

export default connectDB;
