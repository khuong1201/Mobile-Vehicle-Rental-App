import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  final http.Client _client = http.Client();
  static const String baseUrl = 'https://mobile-vehicle-rental-app.onrender.com';
  
  // static const String baseUrl = 'http://192.168.1.163:5000';
  // static const String baseUrl = 'http://10.0.2.2:5000';
  factory ApiClient() => _instance;

  ApiClient._internal();

  http.Client get client => _client;

  void dispose() => _client.close();
}
