import 'package:flutter/material.dart';
import 'package:frontend/api_services/user/update_role.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/user/user_secure_storage.dart';
import 'package:frontend/models/user.dart';

class RoleViewModel extends ChangeNotifier {
  final AuthService authService;

  RoleViewModel({required this.authService});

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  Map<String, dynamic> data = {};

  Future<void> updateUserRole({required String newRole}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final response = await updateUserRoleApi(
      viewModel: this,
      authService: authService,
      newRole: newRole,
    );

    isLoading = false;

    if (response.success) {
      successMessage = response.message;
      data = response.data ?? {};

      debugPrint('Role updated successfully: ${data['user']}');

      // ✅ Cập nhật lại User
      final updatedUser = User.fromJson(data['updatedUser']);
      authService.user = updatedUser;
      await UserSecureStorage.saveUser(updatedUser);
    } else {
      errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<bool> checkRole() async {
    return await authService.checkRoleOwner();
  }
}
