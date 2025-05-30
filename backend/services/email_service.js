const transporter = require('../config/nodemailer');

const sendOTP = async ({ email, otp, purpose }) => {
    try {
        let subject, html;
        switch (purpose) {
            case 'registration':
                subject = 'Your OTP for Email Verification';
                html = `Your OTP for email verification is <b>${otp}</b>. It expires in 10 minutes.`;
                break;
            case 'password-reset':
                subject = 'Your OTP for Password Reset';
                html = `Your OTP for password reset is <b>${otp}</b>. It expires in 10 minutes.`;
                break;
            default:
                throw new Error('Invalid email purpose');
        }

        await transporter.sendMail({
            from: process.env.EMAIL_USER,
            to: email,
            subject,
            html,
        });

        return { message: `OTP sent to ${email} for ${purpose}` };
    } catch (err) {
        throw new Error(`Failed to send email: ${err.message}`);
    }
};

module.exports = { sendOTP };