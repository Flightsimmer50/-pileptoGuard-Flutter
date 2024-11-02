import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Services/userWebService.dart';
import '../Utils/Constantes.dart';
import 'User/loginScreen.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isNotificationEnabled = true;
  bool emergency = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFC987E1),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/splash_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 8.0, left: 8.0, top: 48.0, bottom: 8.0),
          child: ListView(
            children: [
              ListTile(
                title: const Text('Notifications via Email',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Switch(
                  value: isNotificationEnabled,
                  onChanged: (bool value) {
                    print('Switch value: $value');
                    setState(() {
                      isNotificationEnabled = value;
                      print('Notification enabled: $isNotificationEnabled');
                    });
                    updateNotificationSettings(value);
                  },
                  activeColor: const Color(0xFF8200B4),
                ),
              ),
              ListTile(
                title: const Text('Deactivate Emergency Alert',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Switch(
                  value: true,
                  onChanged: (bool value) {
                    setState(() {
                      emergency = value;
                    });
                  },
                  activeColor: const Color(0xFF8200B4),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'Are you sure you want to deactivate your account?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No', style: TextStyle(color: Colors.red),),
                          ),
                          TextButton(
                            onPressed: () async {
                              final storage = FlutterSecureStorage();
                              final id = await storage.read(key: 'id');

                              http.Response? res = await UserWebService()
                                  .desactivateAccount(id!);
                              Navigator.pop(context);
                              if (res?.statusCode == 200) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Information"),
                                      content: const Text(
                                          "Account successfully desactivated!"),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("Dismiss"))
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Server error"),
                                      content: const Text(
                                          "Account could not desactivated! Please try again later."),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Dismiss"))
                                      ],
                                    );
                                  },
                                );
                              }
                              await storage.delete(key: "token").then((value) {
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text('Yes', style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: const Text(
                  'Deactivate Account',
                  style: TextStyle(
                      color: Color(0xFFEF5259), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void updateNotificationSettings(bool isEnabled) async {
    try {
      final response = await http.post(
        Uri.parse('${Constantes.URL_API}/api/notification-settings'),
        body: jsonEncode({'emailEnabled': isEnabled}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Notification settings updated');
      } else {
        print('Failed to update notification settings: ${response.statusCode}');
        setState(() {
          isNotificationEnabled = !isEnabled;
        });
      }
    } catch (e) {
      print('Error updating notification settings: $e');
      setState(() {
        isNotificationEnabled = !isEnabled;
      });
    }
  }
}
