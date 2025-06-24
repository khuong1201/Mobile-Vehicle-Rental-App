import 'package:flutter/material.dart';
import 'package:frontend/api_services/user/update_role.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';


class RoleViewModel extends ChangeNotifier {
  final AuthService authService;

  RoleViewModel({required this.authService});

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> updateUserRole({
    required String userId,
    required String newRole,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final response = await updateUserRoleApi(
      viewModel: this,
      authService: authService,
      userId: userId,
      newRole: newRole,
    );

    isLoading = false;

    if (response.success) {
      successMessage = response.message;
    } else {
      errorMessage = response.message;
    }

    notifyListeners();
  }
}
