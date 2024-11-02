import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/models/drug.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';

class DrugService {
  static const String baseURL = Constantes.URL_API;

  Future<List<Drug>> getAllDrugs() async {
    final response = await http.get(Uri.parse('$baseURL/drugs'));

    if (response.statusCode == 200) {
      Iterable<dynamic> list = json.decode(response.body);
      return List<Drug>.from(list.map((model) => Drug.fromJson(model)));
    } else {
      throw Exception('Échec de chargement des drugs');
    }
  }

  Future<void> deleteDrug(String name) async {
    final response = await http.delete(Uri.parse('$baseURL/drugs/$name'));

    if (response.statusCode == 204) {
      // La suppression a réussi (204 signifie "No Content")
    } else {
      throw Exception('Échec de la suppression du Drug');
    }
  }

  Future<void> addDrug(Drug drug) async {
    final response = await http.post(
      Uri.parse('$baseURL/drugs'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(drug.toJson()),
    );

    if (response.statusCode == 201) {
      // L'ajout a réussi (201 signifie "Created")
    } else {
      throw Exception('Échec de l\'ajout de drug');
    }
  }

  Future<void> updateDrug(String name, Drug updatedDrug) async {
    final response = await http.put(
      Uri.parse('$baseURL/drugs/$name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedDrug.toJson()),
    );

    if (response.statusCode == 200) {
      // La modification a réussi (200 signifie "OK")
    } else {
      throw Exception('Échec de la modification du drug');
    }
  }
}
