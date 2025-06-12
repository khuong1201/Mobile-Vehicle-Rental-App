import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class GetVehicleService {
  static Future<List<Vehicle>> fetchVehiclesFromBackend() async {
    final response = await http.get(Uri.parse('https://your-api-url.com/vehicles'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Vehicle.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }
}