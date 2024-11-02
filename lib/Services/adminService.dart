import 'dart:convert';


import 'package:flutter/material.dart';

import '../Models/UserModel.dart';
import '../Models/feedbacksModel.dart';
import '../Models/user.dart';
import '../Utils/Constantes.dart';

import 'package:http/http.dart' as http;


class AdminService{
  Future<List<UserModel>> getUsers(String token) async {

    final response = await http.get(
      Uri.parse('${Constantes.URL_API}/admin/getUsers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ); 
    if (response?.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response!.body);

      List<dynamic> data = responseData['data'];

      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get users');
    }
  }

  Future<List<FeedbacksModel>> getFeedback(String? id,String token) async {

    final response = await http.get(
      Uri.parse('${Constantes.URL_API}/admin/getFeedback/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response?.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response!.body);

      List<dynamic> data = responseData['data'];

      return data.map((json) => FeedbacksModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get feedback');
    }
  }

  Future<void> updateUserRoleAndNotify(String userId, String newRole,String token,BuildContext context) async {
  final String apiUrl = '${Constantes.URL_API}${Constantes.URL_API_ADMIN}/users/${userId}'; // Replace with your actual API URL

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
      body: jsonEncode({'id': userId, 'role': newRole}),
    
    );

    if (response.statusCode == 200) {
      print('User role updated successfully.');
      SnackBar snackBar = const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('User role updated successfully.!',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      
    } else {
      // Handle error
      SnackBar snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Text(
                'Failed to update user role. Status code: ${response.statusCode}',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception('Failed to update user role: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle error
    print('Error: $e');
  }
}
}

