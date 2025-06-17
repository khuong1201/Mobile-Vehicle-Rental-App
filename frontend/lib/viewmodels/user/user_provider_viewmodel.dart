import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/viewmodels/user/user_secure_storage.dart';


class UserViewModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await UserSecureStorage.getUser();

    _isLoading = false;
    notifyListeners();
  }
}
