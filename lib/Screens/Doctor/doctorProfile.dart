import 'package:epilepto_guard/Screens/Doctor/patientDetail.dart';
import 'package:epilepto_guard/Screens/Doctor/patientsList.dart';
import 'package:epilepto_guard/Services/adminService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Lang/language.dart';
import '../../Localization/language_constants.dart';
import '../../Services/doctorService.dart';
import '../../Utils/Constantes.dart';
import '../../main.dart';
import '../User/loginScreen.dart';

class DoctorProfile extends StatefulWidget {
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  late SharedPreferences _prefs;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // final Connectivity _connectivity = Connectivity();

  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? id;
  String? token;

  bool _darkMode = false;
  bool _offlineMode = false;
  String _preferredLanguage = 'English';
  String _notificationPreferences = 'All';
  String _displayPreference = 'Standard';

  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPreferences();
    // _checkConnectivity();
    fetchData();
  }

  // Future<void> _checkConnectivity() async {
  //   final connectivityResult = await _connectivity.checkConnectivity();
  //   setState(() {
  //     _offlineMode = connectivityResult == ConnectivityResult.none;
  //   });
  // }

  Future<void> fetchData() async {
    final Map<String, String?> data = {
      "token": await _storage.read(key: "token"),
      "firstName": await _storage.read(key: "firstName"),
      "lastName": await _storage.read(key: "lastName"),
      "email": await _storage.read(key: "email"),
      "image": await _storage.read(key: "image"),
      "id": await _storage.read(key: "id"),
    };

    setState(() {
      firstName = data["firstName"];
      lastName = data["lastName"];
      email = data["email"];
      image = data["image"];
      id = data["id"];
      token = data["token"];
    });
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayPreference = _prefs.getString('displayPreference') ?? 'Standard';
      _offlineMode = _prefs.getBool('offlineMode') ?? false;
      _darkMode = _prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, 'Profile'),
          //'Profile',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PatientsList()),
            );
          },
        ),
        // iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: _darkMode ? const Color(0xFF301148) : const Color(0xFFC987E1),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _darkMode
                    ? const [Color(0xFF4B0082), Color(0xFF202020)]
                    : const [Color(0xFFC2A3F7), Color(0xFFFFFFFF)],
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * .3,
              height: MediaQuery.of(context).size.height * .3,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  "assets/images/background/drug.png",
                  // fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * .3,
              height: MediaQuery.of(context).size.height * .3,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  "assets/images/background/drug.png",
                  // fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 250,
            child: Container(
              width: MediaQuery.of(context).size.width * .3,
              height: MediaQuery.of(context).size.height * .3,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  "assets/images/background/drug.png",
                  // fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: _displayPreference == 'Compact' ? 40 : 60,
                          backgroundImage: NetworkImage(
                              '${Constantes.USER_IMAGE_URL}/$image'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${firstName ?? "First Name"} ${lastName ?? "Last Name"}',
                          style: TextStyle(
                            fontSize:
                                _displayPreference == 'Compact' ? 24.0 : 34.0,
                            color: _darkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_displayPreference == 'Detailed')
                          Text(email ?? "Email",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: _darkMode ? Colors.white : Colors.black,
                              )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_displayPreference == 'Detailed') ...[
                    Text(
                      getTranslated(context, 'Account Settings'),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: _darkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SwitchListTile(
                      title: Text(
                        getTranslated(context, 'Dark Mode'),
                        style: TextStyle(
                          color: _darkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _saveDarkMode(value);
                        });
                      },
                    ),
                    // SwitchListTile(
                    //   title: Text('Offline Mode', style: TextStyle(
                    //     color: _darkMode ? Colors.white : Colors.black,)),
                    //   value: _offlineMode,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _saveOfflineMode(value);
                    //     });
                    //   },
                    // ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    getTranslated(context, 'Preferences'),
                    style: TextStyle(
                        fontSize: _displayPreference == 'Compact' ? 16.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: _darkMode ? Colors.white : Colors.black),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     'Preferred Language',
                  //     style: TextStyle(
                  //       fontSize: _displayPreference == 'Compact' ? 16.0 : 18.0,
                  //       color: _darkMode ? Colors.white : Colors.black,
                  //     ),
                  //   ),
                  //   subtitle: DropdownButton<String>(
                  //     value: _preferredLanguage,
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         _preferredLanguage = newValue!;
                  //       });
                  //     },
                  //     dropdownColor: _darkMode ? Color(0xFF301148) : Colors.white,
                  //     items: <String>['english','french','korean'
                  //     ]
                  //         .map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(
                  //           value,
                  //           style: TextStyle(
                  //             color: _darkMode ? Colors.white : Colors.black,
                  //           ),
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),

                  ListTile(
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            getTranslated(context, 'Preferred Language'),
                            style: TextStyle(
                              fontSize: _displayPreference == 'Compact' ? 16.0 : 18.0,
                              color: _darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          Icons.g_translate,
                          color: _darkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 10),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<Language>(
                            onChanged: (Language? language) {
                              _changeLanguage(language!);
                            },
                            items: Language.languageList().map<DropdownMenuItem<Language>>(
                                  (e) => DropdownMenuItem<Language>(
                                value: e,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      e.flag,
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(e.name),
                                  ],
                                ),
                              ),
                            ).toList(),
                            dropdownColor: _darkMode ? const Color(0xFF602F8D) : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ListTile(
                  //   title: Text(
                  //     getTranslated(context, 'Notification Preferences'),
                  //     style: TextStyle(
                  //         fontSize:
                  //             _displayPreference == 'Compact' ? 16.0 : 18.0,
                  //         color: _darkMode ? Colors.white : Colors.black),
                  //   ),
                  //   subtitle: DropdownButton<String>(
                  //     value: _notificationPreferences,
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         _notificationPreferences = newValue!;
                  //       });
                  //     },
                  //     dropdownColor:
                  //         _darkMode ? Color(0xFF301148) : Colors.white,
                  //     items: <String>['All', 'Only Important', 'None']
                  //         .map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(getTranslated(context, value),
                  //             style: TextStyle(
                  //               color: _darkMode ? Colors.white : Colors.black,
                  //             )),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'Display Preferences'),
                      style: TextStyle(
                          fontSize:
                              _displayPreference == 'Compact' ? 16.0 : 18.0,
                          color: _darkMode ? Colors.white : Colors.black),
                    ),
                    subtitle: DropdownButton<String>(
                      value: _displayPreference,
                      onChanged: (String? newValue) {
                        setState(() {
                          _saveDisplayPreference(newValue!);
                          _displayPreference = newValue;
                        });
                      },
                      dropdownColor:
                          _darkMode ? const Color(0xFF301148) : Colors.white,
                      items: <String>['Standard', 'Compact', 'Detailed']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getTranslated(context, value),
                              style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              getTranslated(context, 'Logout'),
                              style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            backgroundColor: _darkMode ? const Color(0xFF301148) : Colors.white,
                            content: Text(
                              getTranslated(context, 'Are you sure you want to logout?'),
                              style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  getTranslated(context, 'No'),
                                  style: TextStyle(
                                    color: _darkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  getTranslated(context, 'Yes'),
                                  style: TextStyle(
                                    color: _darkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmed != null && confirmed) {
                        await _storage.delete(key: "token").then((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }).catchError((error) {
                          print("Error logging out: $error");
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _darkMode ? const Color(0xFF8A4FE9) : Colors.white,
                    ),
                    child: Text(
                      getTranslated(context, 'Logout'),
                      style: TextStyle(
                        color: _darkMode ? Colors.white : const Color(0xFF8A4FE9),
                        fontWeight: FontWeight.bold,
                        fontSize: _displayPreference == 'Compact' ? 15.0 : 17.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showFeedbackDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _darkMode ? const Color(0xFF8A4FE9) : Colors.white,
                    ),
                    child: Text(
                      getTranslated(context, 'Feedback and Suggestions'),
                      style: TextStyle(
                        color: _darkMode ? Colors.white : const Color(0xFF8A4FE9),
                        fontWeight: FontWeight.bold,
                        fontSize: _displayPreference == 'Compact' ? 15.0 : 17.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _showBackupRecoveryDialog(context);
                  //   },
                  //   child: Text(
                  //     'Data Backup and Recovery',
                  //     style: TextStyle(
                  //       color: const Color(0xFF8A4FE9),
                  //       fontWeight: FontWeight.bold,
                  //       fontSize:
                  //       _displayPreference == 'Compact' ? 15.0 : 17.0,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  Future<void> _saveDisplayPreference(String value) async {
    await _prefs.setString('displayPreference', value);
  }

  void _saveOfflineMode(bool value) async {
    await _prefs.setBool('offlineMode', value);
    setState(() {
      _offlineMode = value;
    });
  }

  void _saveDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);
    setState(() {
      _darkMode = value;
    });
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            getTranslated(context, 'Feedback and Suggestions'),
            style: TextStyle(
              color: _darkMode ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: _darkMode ? Color(0xFF301148) : Colors.white,
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                hintText: getTranslated(context, 'Enter your feedback here'),
                hintStyle: TextStyle(
                  color: _darkMode ? Colors.white54 : Colors.black54,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _darkMode ? Colors.white : Colors.black,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _darkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              maxLines: null,
              style: TextStyle(
                color: _darkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await DoctorService()
                    .addFeedback(id!, feedbackController.text, token!);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkMode ? const Color(0xFF8A4FE9) : Colors.white,
              ),
              child: Text(
                getTranslated(context, 'Submit'),
                style: TextStyle(
                  color: _darkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                feedbackController.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkMode ? const Color(0xFF8A4FE9) : Colors.white,
              ),
              child: Text(
                getTranslated(context, 'Cancel'),
                style: TextStyle(
                  color: _darkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBackupRecoveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Backup and Recovery'),
          content: const Text('Choose backup or recovery.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Backup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Recover'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
