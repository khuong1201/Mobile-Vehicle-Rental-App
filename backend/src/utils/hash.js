import bcrypt from "bcrypt";

export async function hash(data, saltRounds) {
  return bcrypt.hash(data, saltRounds);
}

export async function compare(data, hashed) {
  return bcrypt.compare(data, hashed);
}
