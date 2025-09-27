import 'dart:convert';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/models/location/district.dart';
import 'package:frontend/models/location/province.dart';
import 'package:frontend/models/location/ward.dart';
import 'package:http/http.dart' as http;

class LocationApi {
  static final _client = ApiClient().client;
  static const _headers = {'Content-Type': 'application/json'};

  // Tỉnh/Thành
  static Future<ApiResponse<List<Province>>> getAllProvinces() async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/locations/provinces');
    return _handleResponse<List<Province>>(
      () => _client.get(url),
      (data) => data.map((e) => Province.fromJson(e)).toList(),
      errorMsg: 'Lỗi khi lấy tỉnh/thành',
    );
  }

  // POST: Quận/Huyện theo provinceCode
  static Future<ApiResponse<List<District>>> postDistrictsByProvince(int provinceCode) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/locations/districts');
    return _handleResponse<List<District>>(
      () => _client.post(
        url,
        headers: _headers,
        body: jsonEncode({'provinceCode': provinceCode}),
      ),
      (data) => data.map((e) => District.fromJson(e)).toList(),
      errorMsg: 'Lỗi khi lấy quận/huyện (POST)',
    );
  }

  // POST: Phường/Xã theo districtCode
  static Future<ApiResponse<List<Ward>>> postWardsByDistrict(int districtCode) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/locations/wards');
    return _handleResponse<List<Ward>>(
      () => _client.post(
        url,
        headers: _headers,
        body: jsonEncode({'districtCode': districtCode}),
      ),
      (data) => data.map((e) => Ward.fromJson(e)).toList(),
      errorMsg: 'Lỗi khi lấy phường/xã (POST)',
    );
  }

  // Hàm xử lý chung
  static Future<ApiResponse<T>> _handleResponse<T>(
    Future<http.Response> Function() request,
    T Function(List<dynamic>) parser, {
    String errorMsg = 'Lỗi hệ thống',
  }) async {
    try {
      final response = await request();
      // print('URL: ${response.request?.url}, Status Code: ${response.statusCode}, Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return ApiResponse(success: true, data: parser(decoded));
        } else {
          return ApiResponse(success: false, message: 'Dữ liệu trả về không hợp lệ');
        }
      } else {
        return ApiResponse(success: false, message: '$errorMsg: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return ApiResponse(success: false, message: '$errorMsg\nChi tiết: $e');
    }
  }
}
