import 'package:epilepto_guard/Screens/Crise/detailDailyForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Models/dailyForm.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';
import 'package:epilepto_guard/Services/dailyFormService.dart';

enum FormFilter { all, archived }

class DailyFormHistoryScreen extends StatefulWidget {
  @override
  _DailyFormHistoryScreenState createState() => _DailyFormHistoryScreenState();
}

class _DailyFormHistoryScreenState extends State<DailyFormHistoryScreen> {
  List<DailyForm> dailyForms = [];
  FormFilter _currentFilter = FormFilter.all;
  //final dailyFormService = DailyFormService();
  bool isArchivedVisible = false;

  Future<void> fetchDailyForms() async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: "token");

    final response = await http.get(
      Uri.parse('${Constantes.URL_API}/dailyForm/'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        dailyForms = data.map((item) => DailyForm.fromJson(item)).where((form) {
          if (isArchivedVisible) {
            return form.isArchived;
          } else {
            return form.isArchived == (_currentFilter == FormFilter.archived);
          }
        }) /*=>
                form.isArchived == (_currentFilter == FormFilter.archived))*/
            .toList(); // Convertir les données JSON en objets DailyForm
        print("doneeeeeeeeeeeeeee");
      });
    } else {
      throw Exception('Failed to load Forms');
    }
  }
/*
  Future<void> archiveDailyForm(DailyForm form) async {
    try {
      // Récupérer l'ID du formulaire
      String formId = form.id;

      // Appeler l'API backend pour mettre à jour l'état archivé du formulaire
      final String apiUrl = '${Constantes.URL_API}/dailyForm/$formId';
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: "token");
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Si la mise à jour est réussie, vous pouvez mettre à jour l'état local du formulaire
        setState(() {
          // Mettez à jour la propriété isArchived du formulaire dans la liste local de dailyForms
          form.isArchived = true;
          // Supprimer l'élément de la liste dailyForms
          // dailyForms.remove(form);
          // Trouvez l'index de l'élément à supprimer dans la liste dailyForms
          int indexToRemove =
              dailyForms.indexWhere((element) => element.id == form.id);
          // Supprimer l'élément de la liste dailyForms
          dailyForms.removeAt(indexToRemove);
        });
      } else {
        throw Exception('Failed to archive form');
      }
    } catch (e) {
      print('Error archiving form: $e');
    }
  }*/

  Future<void> archiveDailyForm(DailyForm form) async {
    try {
      // Appeler l'API backend pour mettre à jour l'état archivé du formulaire
      final String apiUrl = '${Constantes.URL_API}/dailyForm/${form.id}';
      final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: "token");
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'isArchived': true}), // Envoyer seulement l'état isArchived
      );

      if (response.statusCode == 200) {
        // Si la mise à jour est réussie, vous pouvez mettre à jour l'état local du formulaire
        setState(() {
          // Mettez à jour la propriété isArchived du formulaire dans la liste local de dailyForms
          form.isArchived = true;
          // Supprimer l'élément de la liste dailyForms
          dailyForms.remove(form);
        });
      } else {
        throw Exception('Failed to archive form');
      }
    } catch (e) {
      print('Error archiving form: $e');
    }
  }

  /*Future<void> archiveDailyForm(DailyForm form) async {
    try {
      // Appeler le service pour archiver le formulaire
      final service = dailyFormService();
      final String? formId = await service.sendDataToBackend2(form);

      if (formId != null) {
        // Mettre à jour l'état local du formulaire
        setState(() {
          form.isArchived = true;
        });
      } else {
        throw Exception('Failed to archive form');
      }
    } catch (e) {
      print('Error archiving form: $e');
      // Gérez les erreurs ici
    }
  }
*/
  @override
  void initState() {
    super.initState();
    fetchDailyForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Forms History',
          style: TextStyle(
            color: const Color(0xFF8A4FE9),
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                // _currentFilter = _currentFilter == FormFilter.all
                // ? FormFilter.archived
                //: FormFilter.all;
                isArchivedVisible = !isArchivedVisible;
              });
              // Rechargez les formulaires en fonction du filtre sélectionné
              //fetchDailyForms();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentFilter = FormFilter.all;
                  });
                  fetchDailyForms();
                },
                child: Text(
                  'All',
                  style: TextStyle(
                    color: _currentFilter == FormFilter.all
                        ? Colors.blue
                        : Theme.of(context).textTheme.button!.color,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentFilter = FormFilter.archived;
                  });
                  fetchDailyForms();
                },
                child: Text(
                  'Archived',
                  style: TextStyle(
                    color: _currentFilter == FormFilter.archived
                        ? Colors.blue
                        : Theme.of(context).textTheme.button!.color,
                  ),
                ),
              ),
            ],
          ),
        ),
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
          itemCount: dailyForms.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: UniqueKey(), //Key(dailyForms[index].id),
              background: Container(
                color: Colors.red,
                child: Icon(Icons.archive),
              ),
              onDismissed: (direction) {
                setState(() {
                  dailyForms[index].isArchived = true;
                });
                // Appel de l'API pour mettre à jour l'état archivé du formulaire
                archiveDailyForm(dailyForms[index]);
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListTile(
                  title: Text(
                    'Was created on : ${dailyForms[index].formatCreatedAt()}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DailyFormDetailScreen(dailyForm: dailyForms[index]),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
