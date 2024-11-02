import 'dart:convert';

import 'package:epilepto_guard/Screens/Doctor/patientDetail.dart';
import 'package:http/http.dart';

import '../Models/patientsModel.dart';
import '../Models/sensorModel.dart';
import '../Models/user.dart';
import '../Utils/Constantes.dart';

import 'package:http/http.dart' as http;

class DoctorService {
  Future<List<PatientsModel>> getPatients() async {
    final response = await http.get(
      Uri.parse('${Constantes.URL_API}/doctor/getPatients'),
    );
    if (response?.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response!.body);

      List<dynamic> data = responseData['data'];

      return data.map((json) => PatientsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get patients');
    }
  }

  Future<List<SensorModel>> getSensorData() async {
    final response = await http.get(
      Uri.parse('${Constantes.URL_API}/sensors/609f1519c33d2d001d45e888'),
    );
    print(json.decode(response.body));
    if (response?.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      print("getSensorDataaaaaaaaaaaaaaaaaa");
      print(responseData);

      return responseData.map((json) => SensorModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get sensor data');
    }
  }

  Future<Response?> addFeedback(
      String id, String feedback, String token) async {
    print("-----------------------");
    print(feedback);
    final url = Uri.parse('${Constantes.URL_API}/admin/addFeedback');
    final response = await http.post(
      url,
      body: jsonEncode({'id': id, 'feedback': feedback}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
