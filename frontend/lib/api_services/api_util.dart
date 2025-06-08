import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/viewmodels/google_auth_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkLoginStatus(BuildContext context) async {
  try {
    // Kiểm tra lần đầu mở ứng dụng
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      debugPrint('First launch detected, navigating to WelcomeScreen');
      await prefs.setBool('isFirstLaunch', false);
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/welcome');
      return;
    }
    if (!context.mounted) return;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final gAuthViewModel = Provider.of<GAuthViewModel>(context, listen: false);

    final isLoggedIn = await authViewModel.isLoggedIn() || await gAuthViewModel.isLoggedIn();
    final user = await authViewModel.getUser() ?? await gAuthViewModel.getUser();

    if (!context.mounted) return;
    if (isLoggedIn && user != null) {
      debugPrint('User is logged in: ${user.email}');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      debugPrint('User is not logged in or user data is missing');
      Navigator.pushReplacementNamed(context, '/login');
    }
  } catch (e, stackTrace) {
    debugPrint('Error checking login status: $e\n$stackTrace');
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
}

Future<ApiResponse<Map<String, dynamic>>> callProtectedApi<T extends ChangeNotifier>(
  T viewModel, {
  required String endpoint,
  String method = 'GET',
  Map<String, dynamic>? body,
}) async {
  try {
    // Get access token from the appropriate ViewModel
    String? accessToken;
    if (viewModel is AuthViewModel) {
      accessToken = await viewModel.getAccessToken();
    } else if (viewModel is GAuthViewModel) {
      accessToken = await viewModel.getAccessToken();
    } else {
      debugPrint('Unsupported ViewModel type: ${viewModel.runtimeType}');
      return ApiResponse(success: false, message: 'Unsupported ViewModel');
    }

    if (accessToken == null) {
      debugPrint('No access token available');
      return ApiResponse(success: false, message: 'No access token available');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final uri = Uri.parse('${ApiClient.baseUrl}$endpoint');
    http.Response response;

    switch (method.toUpperCase()) {
      case 'POST':
        response = await ApiClient().client.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        ).timeout(const Duration(seconds: 30));
        break;
      case 'PUT':
        response = await ApiClient().client.put(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        ).timeout(const Duration(seconds: 30));
        break;
      case 'DELETE':
        response = await ApiClient().client.delete(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        ).timeout(const Duration(seconds: 30));
        break;
      case 'GET':
      default:
        response = await ApiClient().client.get(
          uri,
          headers: headers,
        ).timeout(const Duration(seconds: 30));
        break;
    }

    if (response.statusCode == 200) {
      debugPrint('API call successful: endpoint=$endpoint, response=${response.body}');
      return ApiResponse(
        success: true,
        data: jsonDecode(response.body),
        message: 'API call successful',
      );
    } else if (response.statusCode == 401) {
      debugPrint('Access token expired for endpoint=$endpoint, attempting to refresh');
      bool refreshSuccess = false;
      if (viewModel is AuthViewModel) {
        refreshSuccess = await viewModel.refreshToken();
      } else if (viewModel is GAuthViewModel) {
        refreshSuccess = await viewModel.refreshToken();
      }

      if (refreshSuccess) {
        final newAccessToken = viewModel is AuthViewModel
            ? await viewModel.getAccessToken()
            : await (viewModel as GAuthViewModel).getAccessToken();

        if (newAccessToken == null) {
          debugPrint('Failed to get new access token after refresh');
          return ApiResponse(success: false, message: 'Failed to refresh token');
        }

        final retryHeaders = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $newAccessToken',
        };

        http.Response retryResponse;
        switch (method.toUpperCase()) {
          case 'POST':
            retryResponse = await ApiClient().client.post(
              uri,
              headers: retryHeaders,
              body: body != null ? jsonEncode(body) : null,
            ).timeout(const Duration(seconds: 30));
            break;
          case 'PUT':
            retryResponse = await ApiClient().client.put(
              uri,
              headers: retryHeaders,
              body: body != null ? jsonEncode(body) : null,
            ).timeout(const Duration(seconds: 30));
            break;
          case 'DELETE':
            retryResponse = await ApiClient().client.delete(
              uri,
              headers: retryHeaders,
              body: body != null ? jsonEncode(body) : null,
            ).timeout(const Duration(seconds: 30));
            break;
          case 'GET':
          default:
            retryResponse = await ApiClient().client.get(
              uri,
              headers: retryHeaders,
            ).timeout(const Duration(seconds: 30));
            break;
        }

        if (retryResponse.statusCode == 200) {
          debugPrint('Retry API call successful: endpoint=$endpoint, response=${retryResponse.body}');
          return ApiResponse(
            success: true,
            data: jsonDecode(retryResponse.body),
            message: 'Retry API call successful',
          );
        } else {
          debugPrint('Retry API call failed: ${retryResponse.statusCode} - ${retryResponse.body}');
          return ApiResponse(
            success: false,
            message: 'Retry API call failed: ${retryResponse.statusCode} - ${retryResponse.body}',
          );
        }
      } else {
        debugPrint('Token refresh failed for endpoint=$endpoint');
        // Call logout based on ViewModel type
        if (viewModel is AuthViewModel) {
          await viewModel.logout('', '');
        } else if (viewModel is GAuthViewModel) {
          await viewModel.signOut();
        }
        return ApiResponse(success: false, message: 'Token refresh failed');
      }
    } else if (response.statusCode == 400) {
      debugPrint('Bad request for endpoint=$endpoint: ${response.statusCode} - ${response.body}');
      return ApiResponse(
        success: false,
        message: response.body.isNotEmpty ? response.body : 'Bad request: ${response.statusCode}',
      );
    } else {
      debugPrint('API call failed for endpoint=$endpoint: ${response.statusCode} - ${response.body}');
      return ApiResponse(
        success: false,
        message: response.body.isNotEmpty ? response.body : 'API call failed: ${response.statusCode}',
      );
    }
  } catch (e, stackTrace) {
    debugPrint('API call error for endpoint=$endpoint: $e\n$stackTrace');
    return ApiResponse(success: false, message: 'Error: $e');
  }
}