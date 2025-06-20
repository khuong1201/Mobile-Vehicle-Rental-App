import 'dart:convert';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';

class LocationApi {
  static Future<ApiResponse<List<dynamic>>> getAllProvinces() async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/location/provinces');
    try {
      final response = await ApiClient().client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> provinces = jsonDecode(response.body);
        return ApiResponse(success: true, data: provinces);
      } else {
        return ApiResponse(success: false, message: 'Lỗi khi lấy tỉnh/thành');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<List<dynamic>>> getDistrictsByProvince(int provinceCode) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/location/districts/$provinceCode');
    try {
      final response = await ApiClient().client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> districts = jsonDecode(response.body);
        return ApiResponse(success: true, data: districts);
      } else {
        return ApiResponse(success: false, message: 'Lỗi khi lấy quận/huyện');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<List<dynamic>>> getWardsByDistrict(int districtCode) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/location/wards/$districtCode');
    try {
      final response = await ApiClient().client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> wards = jsonDecode(response.body);
        return ApiResponse(success: true, data: wards);
      } else {
        return ApiResponse(success: false, message: 'Lỗi khi lấy phường/xã');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<List<dynamic>>> postDistrictsByProvince(int provinceCode) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/location/districts');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'provinceCode': provinceCode}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> districts = jsonDecode(response.body);
        return ApiResponse(success: true, data: districts);
      } else {
        return ApiResponse(success: false, message: 'Lỗi khi lấy quận/huyện');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<List<dynamic>>> postWardsByDistrict(int districtCode) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/location/wards');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'districtCode': districtCode}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> wards = jsonDecode(response.body);
        return ApiResponse(success: true, data: wards);
      } else {
        return ApiResponse(success: false, message: 'Lỗi khi lấy phường/xã');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }
}
