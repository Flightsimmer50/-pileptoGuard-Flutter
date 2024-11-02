import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Models/seizure.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';

class CriseService {
  static const String baseURL = Constantes.URL_API;

  final storage = FlutterSecureStorage();

  Future<String?> createSeizure(Seizure seizureData) async {
    String? authToken = await storage.read(key: 'token');
    if (authToken == null) {
      // Handle case where token is not found
      return null;
    }

    final url = '$baseURL/seizures';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $authToken', // Add the bearer token to the headers
        },
        body: jsonEncode(seizureData.toJson()),
      );

      if (response.statusCode == 201) {
        // Successful request, process the response if needed
        final responseData = jsonDecode(response.body);
        return responseData[
            'seizureId']; // Retrieve the ID of the created seizure
      } else {
        // Request failed, log the error code
        print('Error in request: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle connection or processing errors
      print('Error sending data to backend: $e');
      return null;
    }
  }
}
