import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/models/Forum.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';

class ForumService {
  static const String baseURL = Constantes.URL_API;

  Future<List<Forum>> getAllFeedbacks() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/description'));

      if (response.statusCode == 200) {
        // Vérifiez si la réponse n'est pas nulle avant de la décoder.
        if (response.body.isNotEmpty) {
          Iterable<dynamic> list = json.decode(response.body);
          return List<Forum>.from(list.map((model) => Forum.fromJson(model)));
        } else {
          return []; // Retourner une liste vide si la réponse est vide.
        }
      } else {
        throw Exception('Échec de chargement des forums');
      }
    } catch (e) {
      throw Exception('Erreur lors de la demande HTTP: $e');
    }
  }

  Future<void> addFeedback(Forum forum) async {
  final response = await http.post(
    Uri.parse('$baseURL/description'), // Utilisation de l'URL originale
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(forum.toJson()),
  );

  if (response.statusCode == 201) {
    // L'ajout a réussi (201 signifie "Created")
  } else {
    throw Exception('Échec de l\'ajout de desc');
  }
}

 Future<void> deleteFeedback(String description) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseURL/description/$description'),
      );

      if (response.statusCode == 204) {
        // La suppression a réussi (204 signifie "No Content")
      } else if (response.statusCode == 404) {
        throw Exception('Forum non trouvé');
      } else {
        throw Exception('Échec de la suppression du forum');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression du forum: $e');
    }
  }

  Future<void> updateFeedback(String description, Forum updatedDescription) async {
    final response = await http.put(
      Uri.parse('$baseURL/description/$description'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedDescription.toJson()),
    );

    if (response.statusCode == 200) {
      // La modification a réussi (200 signifie "OK")
    } else {
      throw Exception('Échec de la modification du desc');
    }
  }

}
