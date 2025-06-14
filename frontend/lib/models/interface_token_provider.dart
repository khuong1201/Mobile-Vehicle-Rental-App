import 'package:frontend/models/user.dart';

abstract class TokenProviderInterface {
  Future<String?> getAccessToken();
  Future<bool> refreshToken();
  Future<bool> logout();
  Future<bool> isLoggedIn();
  Future<User?> getUser();
}