import nodemailer from "nodemailer";

export default class EmailProvider {
  constructor() {
    this.transporter = nodemailer.createTransport({
      service: "gmail", 
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    });
  }

  async send(to, subject, body) {
    const info = await this.transporter.sendMail({
      from: `"Rental Vehicle App" <${process.env.EMAIL_USER}>`,
      to,
      subject,
      text: body
    });
    return info.messageId; 
  }
}
