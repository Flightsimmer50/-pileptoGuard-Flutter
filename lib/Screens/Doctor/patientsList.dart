import 'package:epilepto_guard/Models/patientsModel.dart';
import 'package:epilepto_guard/Screens/Doctor/doctorProfile.dart';
import 'package:epilepto_guard/Screens/Doctor/patientDetail.dart';
import 'package:epilepto_guard/Services/doctorService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Lang/language.dart';
import '../../Localization/language_constants.dart';
import '../../Utils/Constantes.dart';
import '../../main.dart';

class PatientsList extends StatefulWidget {
  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  List<PatientsModel> patientsArray = [];
  final storage = const FlutterSecureStorage();
  String? image;
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _initPreferences();
    fetchData();
  }

  Future<void> fetchData() async {
    image = await storage.read(key: "image");
    try {
      var patients = await DoctorService().getPatients();
      setState(() {
        patientsArray = patients;
      });
    } catch (error) {
      print('Error getting patients: $error');
    }
  }

  Future<void> _initPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('${Constantes.USER_IMAGE_URL}/$image');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              getTranslated(context, 'Patients List'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorProfile()),
                );
              },
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage('${Constantes.USER_IMAGE_URL}/$image'),
              ),
            ),
          ],
        ),
        backgroundColor: _darkMode ? Color(0xFF301148) : Color(0xFFC987E1),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _darkMode
                ? [const Color(0xFF4B0082), const Color(0xFF202020)]
                : [const Color(0xFFC2A3F7), const Color(0xFFFFFFFF)],
          ),
        ),
        child: ListView.builder(
          itemCount: patientsArray.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            getTranslated(context, 'Patient Name'),
                            style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            getTranslated(context, 'Height'),
                            style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            getTranslated(context, 'Weight'),
                            style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              final patient = patientsArray[index - 1];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  color: const Color(0xFFF9C0FF),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            '${patient.firstName!} ${patient.lastName!}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            patient.height?.toStringAsFixed(1) ?? "",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            patient.weight?.toStringAsFixed(1) ?? "",
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[700],
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientDetail(patient: patient)));
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
