import 'dart:convert';
import 'package:epilepto_guard/Models/dailyForm.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class dailyFormService {
  static const String baseURL = Constantes.URL_API;

  Future<String?> getToken() async {
    final storage = const FlutterSecureStorage();

    return await storage.read(key: 'token');
  }

  Future<String?> sendDataToBackend2(DailyForm formData) async {
    final url = baseURL + '/dailyForm';
    final token = await getToken();
    print(token);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData.toJson()),
      );

      if (response.statusCode == 200) {
        // La requête a réussi, traitez la réponse si nécessaire
        final responseData = jsonDecode(response.body);
        // return responseData['formId']; // Récupérer l'ID du formulaire en question
      } else {
        // La requête a échoué, affichez le code d'erreur
        print('Erreur lors de la requête : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Gérer les erreurs de connexion ou de traitement
      print('Erreur lors de l\'envoi des données au backend : $e');
      return null;
    }
  }





  Future<DailyForm?> fetchFormData(String formDataId) async {
    final url = '$baseURL/dailyForm/$formDataId';
    final token = await getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DailyForm.fromJson(jsonData);
      } else {
        print(
            'Erreur lors de la récupération des données du formulaire (1) : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des données du formulaire (2) : $e');
      return null;
    }
  }

  /*Future<DailyForm?> getFormData(String crisisId) async {
    final url = '$baseURL/dailyForm/';//lezem nrecupereha bel id mteeha
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DailyForm.fromJson(jsonData);
      } else {
        print(
            'Erreur lors de la récupération des données du formulaire : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des données du formulaire : $e');
      return null;
    }
  }*/

  /* Future<bool> checkIfFormSubmitted(String crisisId) async {
    final url = '$baseURL/seizures/$crisisId';
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);

        return jsonData != null;
      } else {
        print(
            'Erreur lors de la vérification de la soumission du formulaire 1 : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print(
          'Erreur lors de la vérification de la soumission du formulaire 2 : $e');
      return false;
    }
  }*/
}
