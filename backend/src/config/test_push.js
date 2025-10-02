
import admin from 'firebase-admin';
import env from '../config/env.js'; // file env.js bạn đã viết

// --- Parse service account từ env ---
const serviceAccount = env.FIREBASE_SERVICE_ACCOUNT;

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

const messaging = admin.messaging();

/**
 * Gửi push cho nhiều token
 */
async function sendPush(tokens, title, body, data = {}) {
  try {
    const results = await Promise.all(
      tokens.map(token =>
        messaging
          .send({
            notification: { title, body },
            data,
            token,
          })
          .then(msgId => ({ token, success: true, msgId }))
          .catch(err => ({ token, success: false, error: err }))
      )
    );

    results.forEach(res => {
      if (res.success) console.log(`✅ Sent to ${res.token}, messageId: ${res.msgId}`);
      else console.error(`❌ Failed token: ${res.token}`, res.error);
    });
  } catch (err) {
    console.error('Error sending push:', err);
  }
}

/**
 * Test gửi push
 */
async function test() {
  const testTokens = [
    'deshPttsQTK5PMZhYPF79v:APA91bGOqslEu1Z5t2n0Ty7Yaote-f5WFUF27Dz2yHIRo4fnL6wnIwe1B8Yhk9pTT17CwS6UEPnm71-25gE5sijiwQ3RYxylv7zTK9gLpv4KRm6GRTdeoQg', // thay bằng token thực tế
  ];

  await sendPush(testTokens, 'Test Push via ENV', 'Hello from Node.js!', { customKey: 'customValue' });
}

test();
