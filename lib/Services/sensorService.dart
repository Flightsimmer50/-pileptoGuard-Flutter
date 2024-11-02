import 'dart:convert';
import 'package:epilepto_guard/Models/sensor.dart';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Utils/Constantes.dart';

class SensorService {
  static const String baseURL = Constantes.URL_API;

  Future<void> postData(Sensor sensorData) async {
    final url = '$baseURL/sensors';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(sensorData.toJson()),
      );

      if (response.statusCode == 201) {
        // Successful request
        print('Data posted successfully');
      } else {
        // Request failed, log the error code
        print('Error in request: ${response.statusCode}');
      }
    } catch (e) {
      // Handle connection or processing errors
      print('Error posting data: $e');
    }
  }
}
