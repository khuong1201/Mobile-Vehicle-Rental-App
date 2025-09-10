const OTP_LENGTH = 5;

function generateOtp(length = OTP_LENGTH) {
  return Math.floor(Math.random() * 10 ** length)
    .toString()
    .padStart(length, "0");
}

export default { generateOtp };
