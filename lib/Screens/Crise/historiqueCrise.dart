import 'package:epilepto_guard/Screens/Crise/detailCrise.dart';
import 'package:flutter/material.dart';
import 'package:epilepto_guard/Models/crise.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Utils/Constantes.dart';

class CrisisHistoryScreen extends StatefulWidget {
  @override
  _CrisisHistoryScreenState createState() => _CrisisHistoryScreenState();
}

class _CrisisHistoryScreenState extends State<CrisisHistoryScreen> {
  List<Crisis> crises = [];

  /*Future<void> fetchCrises() async {
    final response =
        await http.get(Uri.parse('${Constantes.URL_API}/seizures/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        crises = data.map((item) => Crisis.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load seizures');
    }
  }*/

  Future<void> fetchCrises() async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: "token");

    final response = await http.get(
      Uri.parse('${Constantes.URL_API}/seizures/'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        crises = data.map((item) => Crisis.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load seizures');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCrises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seizures History',
          style: TextStyle(
            color: const Color(0xFF8A4FE9),
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: crises.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                title: Text(
                  DateFormat.yMMMd().format(crises[index].date),
                  style: TextStyle(fontSize: 18.0),
                ),
                subtitle: Text(
                  crises[index].type.toString().split('.')[1],
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CrisisDetailScreen(crisis: crises[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
