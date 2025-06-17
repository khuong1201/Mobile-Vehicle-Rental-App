import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse<dynamic>> callProtectedApi<T extends ChangeNotifier>(
  T viewModel, {
  required String endpoint,
  required AuthService authService,
  String method = 'GET',
  Map<String, dynamic>? body,
}) async {
  try {
    final accessToken = await authService.getAccessToken();
    if (accessToken == null) {
      return ApiResponse(success: false, message: 'No access token available');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final uri = Uri.parse('${ApiClient.baseUrl}$endpoint');

    Future<http.Response> makeRequest(Map<String, String> headers) async {
      final client = ApiClient().client;
      switch (method.toUpperCase()) {
        case 'POST':
          return await client
              .post(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 30));
        case 'PUT':
          return await client
              .put(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 30));
        case 'DELETE':
          return await client
              .delete(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 30));
        case 'GET':
        default:
          return await client.get(uri, headers: headers).timeout(const Duration(seconds: 30));
      }
    }

    ApiResponse<dynamic> handleResponse(http.Response response) {
      switch (response.statusCode) {
        case 200:
          return ApiResponse(
            success: true,
            data: jsonDecode(response.body),
            message: 'API call successful',
          );
        case 400:
          return ApiResponse(
            success: false,
            message: response.body.isNotEmpty ? response.body : 'Bad request',
          );
        default:
          return ApiResponse(
            success: false,
            message: response.body.isNotEmpty ? response.body : 'API call failed: ${response.statusCode}',
          );
      }
    }

    var response = await makeRequest(headers);
    if (response.statusCode == 200) {
      return handleResponse(response);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      final refreshSuccess = await authService.refreshToken();
      if (!refreshSuccess) {
        await authService.logout();
        return ApiResponse(success: false, message: 'Token refresh failed');
      }

      final newAccessToken = await authService.getAccessToken();
      if (newAccessToken == null) {
        await authService.logout();
        return ApiResponse(success: false, message: 'Failed to refresh token');
      }

      final retryResponse = await makeRequest({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $newAccessToken',
      });

      return handleResponse(retryResponse);
    }

    return handleResponse(response);
  } catch (e) {
    return ApiResponse(success: false, message: 'Error: $e');
  }
}