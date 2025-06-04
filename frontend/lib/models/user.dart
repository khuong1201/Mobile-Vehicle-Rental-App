import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  User({
    required this.uid, 
    required this.email, 
    this.displayName,
    this.photoUrl
  });

  factory User.fromGoogleAccount(GoogleSignInAccount account) {
    return User(
      uid: account.id,
      email: account.email,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
    );
  }
}
