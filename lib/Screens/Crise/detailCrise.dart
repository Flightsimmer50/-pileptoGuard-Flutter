import 'dart:convert';
import 'package:epilepto_guard/Screens/Crise/submittedForm.dart';
import 'package:epilepto_guard/Services/postFormService.dart';
import 'package:epilepto_guard/Models/postCriseForm.dart';
import 'package:epilepto_guard/Screens/Crise/postCriseFormulaire.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';
import 'package:flutter/material.dart';
import 'package:epilepto_guard/Models/crise.dart' as CriseModel;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Utils/Constantes.dart';

class CrisisDetailScreen extends StatefulWidget {
  final CriseModel.Crisis crisis;
  final PostFormService _postFormService = PostFormService();

  CrisisDetailScreen({required this.crisis});

  @override
  _CrisisDetailScreenState createState() => _CrisisDetailScreenState();
}

class _CrisisDetailScreenState extends State<CrisisDetailScreen> {
  //late List<PostCriseFormData> formData = [];
  bool isFormSubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkIfFormSubmitted();
  }

  Future<void> _checkIfFormSubmitted() async {
    try {
      // Récupérer le formulaire associé à la crise en utilisant l'ID de la crise
      bool submitted = await widget._postFormService
          .checkIfFormSubmitted(widget.crisis.idCrise);

      print("submitted");
      print(submitted);
      setState(() {
        isFormSubmitted = submitted;
      });
    } catch (e) {
      print('Error checking form submission: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seizure Details',
          style: TextStyle(
            color: const Color(0xFF8A4FE9),
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                'Date of Seizure:',
                // Format the date to year, month, and day format
                DateFormat.yMMMd().format(widget.crisis.date),
              ),
              _buildDetailItem(
                'Start Time:',
                '${widget.crisis.startTime.hour}:${widget.crisis.startTime.minute}',
              ),
              _buildDetailItem(
                'End Time:',
                '${widget.crisis.endTime.hour}:${widget.crisis.endTime.minute}',
              ),
              _buildDetailItem(
                'Duration:',
                widget.crisis.duration.toString(),
              ),
              _buildDetailItem(
                'Type of Seizure:',
                widget.crisis.type.toString().split('.').last,
              ),
              _buildDetailItem('Location:', widget.crisis.location),
              _buildDetailItem(
                'Emergency Services Called:',
                widget.crisis.emergencyServicesCalled ? 'Yes' : 'No',
              ),
              _buildDetailItem(
                'Medical Assistance:',
                widget.crisis.medicalAssistance ? 'Yes' : 'No',
              ),
              _buildDetailItem(
                'Severity:',
                widget.crisis.severity,
              ),
              SizedBox(height: 20),
              // Button to display associated form
              Center(
                child: TextButton(
                  onPressed: () async {
                    // Vérifier si la crise a un formulaire associé soumis
                    if (isFormSubmitted) {
                      // Afficher une autre interface pour afficher les données du formulaire en mode lecture seule
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubmittedForm(id: widget.crisis.idCrise),
                             
                        ),
                      );
                    } else {
                      // Afficher l'interface habituelle pour saisir de nouvelles données dans le formulaire
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostCriseFormulaire(
                            id: widget.crisis.idCrise,
                            postFormService: widget._postFormService,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Seizure Form',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<PostCriseFormData>> fetchFormData(String formDataId) async {
    final response =
        await http.get(Uri.parse('${Constantes.URL_API}/seizures/$formDataId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response!.body);
      print("list dataaaaaaaaaaaaaaaaaaaaa");
      print(data.map((json) => PostCriseFormData.fromJson(json)).toList());
      return data.map((json) => PostCriseFormData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load form data');
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.0, // Maximum width of the label
            padding: EdgeInsets.all(10.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8A4FE9),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                value,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
