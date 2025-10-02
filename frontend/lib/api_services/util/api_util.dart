import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:path/path.dart' as path;

Future<ApiResponse<dynamic>> callProtectedApi<T extends ChangeNotifier>(
  T viewModel, {
  required String endpoint,
  required AuthService authService,
  String method = 'GET',
  Map<String, dynamic>? body,
  Map<String, dynamic>? fields,
  Map<String, List<File>>? files,
  bool isMultipart = false,
}) async {
  try {
    debugPrint(
      '🚀 Calling API: $endpoint, Method: $method, Multipart: $isMultipart',
    );
    final accessToken = await authService.getAccessToken();
    if (accessToken == null) {
      debugPrint('❌ No access token found');
      return ApiResponse(success: false, message: 'Không có access token');
    }
    debugPrint('🔑 Access token: $accessToken');

    final uri = Uri.parse('${ApiClient.baseUrl}$endpoint');
    final client = ApiClient().client;

    Future<http.Response> sendJsonRequest(String token) async {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      debugPrint('📤 JSON headers: $headers');
      debugPrint('📤 JSON body: $body');

      switch (method.toUpperCase()) {
        case 'POST':
          return await client.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        case 'PUT':
          return await client.put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        case 'PATCH':
          return await client.patch(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        case 'DELETE':
          if (body != null) {
            return await client.delete(
              uri,
              headers: headers,
              body: jsonEncode(body),
            );
          } else {
            return await client.delete(uri, headers: headers);
          }
        case 'GET':
        default:
          return await client.get(uri, headers: headers);
      }
    }

    Future<http.Response> sendMultipartRequest(String token) async {
      debugPrint('📦 Multipart fields: $fields');
      debugPrint(
        '📦 Multipart files: ${files?.entries.map((e) => '${e.key}: ${e.value.map((f) => f.path).toList()}').join(', ') ?? '[]'}',
      );

      final effectiveMethod =
          (method.toUpperCase() == 'POST' || method.toUpperCase() == 'PUT')
              ? method.toUpperCase()
              : 'POST';

      final request = http.MultipartRequest(effectiveMethod, uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      if (fields != null) {
        final encodedFields = <String, String>{};
        fields.forEach((key, value) {
          if (value == null) return;
          if (value is Map || value is List) {
            encodedFields[key] = jsonEncode(value);
          } else {
            encodedFields[key] = value.toString();
          }
        });
        debugPrint('📦 Encoded multipart fields: $encodedFields');
        request.fields.addAll(encodedFields);
      }

      if (files != null) {
        for (final entry in files.entries) {
          final fieldName = entry.key;
          for (final file in entry.value) {
            if (await file.exists()) {
              final fileName = path.basename(file.path).toLowerCase();
              final extension = path
                  .extension(fileName)
                  .toLowerCase()
                  .replaceAll('.', '');
              final contentType = MediaType(
                'image',
                extension == 'png' ? 'png' : 'jpeg',
              );

              debugPrint('📎 Adding file: ${file.path}, field: $fieldName');

              request.files.add(
                await http.MultipartFile.fromPath(
                  fieldName,
                  file.path,
                  contentType: contentType,
                  filename: fileName,
                ),
              );
            } else {
              debugPrint('❌ File not found: ${file.path}');
            }
          }
        }
      } else {
        debugPrint('⚠️ No files provided for multipart request');
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint(
        '📥 Response body: ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}',
      );
      return response;
    }

    Future<http.Response> makeRequest(String token) async {
      return isMultipart
          ? await sendMultipartRequest(token)
          : await sendJsonRequest(token);
    }

    Future<ApiResponse> handleResponse(http.Response response) async {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return ApiResponse(success: true, message: 'Phản hồi rỗng từ server');
        }
        try {
          final body = jsonDecode(response.body);
          return ApiResponse(
            success: true,
            data: body,
            message:
                body is Map<String, dynamic>
                    ? body['message'] ?? 'Thành công'
                    : 'Thành công',
          );
        } catch (e) {
          debugPrint('❌ JSON parse error: $e');
          return ApiResponse(success: false, message: 'Lỗi phân tích JSON: $e');
        }
      } else {
        debugPrint('❌ Server error: ${response.statusCode}');
        return ApiResponse(
          success: false,
          message:
              'Lỗi server: ${response.statusCode} - ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}',
        );
      }
    }

    // Step 1: Try request
    http.Response response = await makeRequest(accessToken);

    // Step 2: Handle token expired
    if (response.statusCode == 401 || response.statusCode == 403) {
      debugPrint('🔄 Token expired, refreshing...');
      final refreshed = await authService.refreshToken();
      if (!refreshed) {
        debugPrint('❌ Token refresh failed');
        await authService.logout();
        return ApiResponse(
          success: false,
          message: 'Token hết hạn, vui lòng đăng nhập lại',
        );
      }

      final newAccessToken = await authService.getAccessToken();
      if (newAccessToken == null) {
        debugPrint('❌ Failed to get new token');
        await authService.logout();
        return ApiResponse(
          success: false,
          message: 'Không thể lấy lại token mới',
        );
      }
      debugPrint('🔑 New access token: $newAccessToken');
      response = await makeRequest(newAccessToken);
    }

    // Step 3: Trả về kết quả
    return await handleResponse(response);
  } catch (e) {
    debugPrint('❌ API call error: $e');
    return ApiResponse(success: false, message: 'Lỗi ngoại lệ: $e');
  }
}
