import 'dart:convert';
import 'package:epilepto_guard/Models/postCriseForm.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PostFormService {
  static const String baseURL = Constantes.URL_API;

  Future<String?> getToken() async {
    final storage = const FlutterSecureStorage();

    return await storage.read(key: 'token');
  }

  Future<String?> sendDataToBackend(PostCriseFormData formData) async {
    final url = baseURL + '/postCriseForm';
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
        return responseData['criseId']; // Récupérer l'ID de la crise
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
/*
  Future<PostCriseFormData?> getFormData(String crisisId) async {
    final url = '$baseURL/seizures/$crisisId';
    // '/postCriseForm/getPostCriseFormDataByCriseId'; // L'URL pour récupérer les données du formulaire
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PostCriseFormData.fromJson(jsonData);
      } else {
        print(
            'Erreur lors de la récupération des données du formulaire 4 : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des données du formulaire 5 : $e');
      return null;
    }
  }*/

  Future<PostCriseFormData?> getFormData(String crisisId) async {
    final url = '$baseURL/seizures/$crisisId';
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final formData = jsonData['formData'];

        // Vérifiez si formData est null
        if (formData != null) {
          return PostCriseFormData.fromJson(formData);
        } else {
          // Si formData est null, retournez null
          return null;
        }
      } else {
        print(
            'Erreur lors de la récupération des données du formulaire 5 : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des données du formulaire 6 : $e');
      return null;
    }
  }

  Future<bool> checkIfFormSubmitted(String crisisId) async {
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

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return jsonData['formData'] != null;
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
  }
}
