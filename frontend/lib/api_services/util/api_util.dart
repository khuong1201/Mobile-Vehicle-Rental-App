import 'dart:convert';
import 'dart:io';
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
  Map<String, String>? fields,
  Map<String, List<File>>? files,
  bool isMultipart = false,
}) async {
  try {
    final accessToken = await authService.getAccessToken();
    if (accessToken == null) {
      return ApiResponse(success: false, message: 'Không có access token');
    }

    final uri = Uri.parse('${ApiClient.baseUrl}$endpoint');
    final client = ApiClient().client;

    Future<http.Response> sendJsonRequest(String token) async {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      switch (method.toUpperCase()) {
        case 'POST':
          return await client.post(uri, headers: headers, body: jsonEncode(body));
        case 'PUT':
          return await client.put(uri, headers: headers, body: jsonEncode(body));
        case 'DELETE':
          return await client.delete(uri, headers: headers, body: jsonEncode(body));
        case 'GET':
        default:
          return await client.get(uri, headers: headers);
      }
    }

    Future<http.Response> sendMultipartRequest(String token) async {
      final request = http.MultipartRequest(method.toUpperCase(), uri);
      request.headers['Authorization'] = 'Bearer $token';
      if (fields != null) request.fields.addAll(fields);

      if (files != null) {
        for (final entry in files.entries) {
          for (final file in entry.value) {
            final fileStream = http.MultipartFile.fromBytes(
              entry.key,
              await file.readAsBytes(),
              filename: file.path.split('/').last,
            );
            request.files.add(fileStream);
          }
        }
      }

      final streamed = await request.send();
      return await http.Response.fromStream(streamed);
    }

    Future<http.Response> makeRequest(String token) async {
      return isMultipart
          ? await sendMultipartRequest(token)
          : await sendJsonRequest(token);
    }

    Future<ApiResponse> handleResponse(http.Response response) async {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(success: true, data: body, message: body?['message'] ?? 'Thành công');
      } else {
        return ApiResponse(success: false, message: body?['message'] ?? 'Lỗi: ${response.statusCode}');
      }
    }

    // Step 1: Try request
    http.Response response = await makeRequest(accessToken);

    // Step 2: Handle token expired
    if (response.statusCode == 401 || response.statusCode == 403) {
      final refreshed = await authService.refreshToken();
      if (!refreshed) {
        await authService.logout();
        return ApiResponse(success: false, message: 'Token hết hạn, vui lòng đăng nhập lại');
      }

      final newAccessToken = await authService.getAccessToken();
      if (newAccessToken == null) {
        await authService.logout();
        return ApiResponse(success: false, message: 'Không thể lấy lại token mới');
      }

      response = await makeRequest(newAccessToken);
    }

    // Step 3: Trả về kết quả
    return await handleResponse(response);
  } catch (e) {
    debugPrint('❌ Lỗi gọi API: $e');
    return ApiResponse(success: false, message: 'Lỗi ngoại lệ: $e');
  }
}
