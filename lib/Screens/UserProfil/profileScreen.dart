import 'dart:io';

import 'package:epilepto_guard/Components/drawer.dart';
import 'package:epilepto_guard/Screens/Calendar/CalendarScreen.dart';
import 'package:epilepto_guard/Screens/Crise/historiqueCrise.dart';
import 'package:epilepto_guard/Screens/Crise/historiqueDailyForm.dart';
import 'package:epilepto_guard/Screens/Drugs/ListDrug.dart';
import 'package:epilepto_guard/Screens/MedicalSheet/medicalSheetScreen.dart';
import 'package:epilepto_guard/Screens/User/loginScreen.dart';
import 'package:epilepto_guard/Screens/UserProfil/image.dart';
import 'package:epilepto_guard/Screens/UserProfil/updateProfileScreen.dart';
import 'package:epilepto_guard/Utils/Constantes.dart';
import 'package:epilepto_guard/colors.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Services/userWebService.dart';
import '../settings.dart';
// Placeholder button text

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 5;
  String? fullName;
  String? image;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = FlutterSecureStorage();

    String? loadedFirstName = await storage.read(key: "firstName");
    String? loadedLastName = await storage.read(key: "lastName");
    String? loadedEmail = await storage.read(key: "email");
    String? loadedImage = await storage.read(key: "image");

    // Ensure there's a space between first name and last name only if both are not null
    String? loadedFullName = [loadedFirstName, loadedLastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(" ");

    if (mounted) {
      setState(() {
        fullName = loadedFullName.isNotEmpty ? loadedFullName : "Your Name";
        image = loadedImage ?? '';
        email = loadedEmail ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double DefaultSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFC987E1),
      ),
      drawer: Drawers(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background/login.png"),
                  // Specify the path to your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Your existing content in a SingleChildScrollView
            SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.all(16.0), // Adjust padding if necessary
                child: Column(
                  children: [
                    // Your existing widgetSingleChildScrollView(
                    Container(
                      padding: const EdgeInsets.all(DefaultSize),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                '${Constantes.USER_IMAGE_URL}/$image',
                                fit: BoxFit
                                    .cover, // This ensures the image covers the container bounds
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            fullName ?? "Loading...",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            email ?? "Loading...",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProfileScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFF8A4FE9), // Background color
                              ),
                              child: const Text(
                                'Edit Profile',
                                // Make sure to replace 'Edit Profile' with a variable if it's dynamic
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 30,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          // MENU
                          // ProfileMenuWidget(
                          //     title: "Settings",
                          //     icon: LineAwesomeIcons.cog,
                          //     onPress: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) => Settings()));
                          //     }),
                          ProfileMenuWidget(
                              title: "Calendar",
                              icon: LineAwesomeIcons.calendar,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CalendarScreen()));
                              }),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 10),
                          ProfileMenuWidget(
                              title: "Medical File",
                              icon: LineAwesomeIcons.medical_notes,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MedicalSheetScreen()));
                              }),
                          ProfileMenuWidget(
                              title: "Crisis History",
                              icon: LineAwesomeIcons.history,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CrisisHistoryScreen()));
                              }),

                            ProfileMenuWidget(
                              title: "Daily forms history",
                              icon: LineAwesomeIcons.history,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DailyFormHistoryScreen()));
                              }),

                          ProfileMenuWidget(
                              title: "Drugs",
                              icon: LineAwesomeIcons.history,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ListDrug()));
                              }),
                          ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to desactivate your account?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final storage =
                                              FlutterSecureStorage();
                                          final id =
                                              await storage.read(key: 'id');

                                          http.Response? res =
                                              await UserWebService()
                                                  .desactivateAccount(id!);
                                          Navigator.pop(context);
                                          if (res?.statusCode == 200) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text("Information"),
                                                  content: const Text(
                                                      "Account successfully desactivated!"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            "Dismiss"))
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Server error"),
                                                  content: const Text(
                                                      "Account could not desactivated! Please try again later."),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            "Dismiss"))
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          await storage
                                              .delete(key: "token")
                                              .then((value) {});
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                          );
                                        },
                                        child: Text('Yes',
                                            style:
                                                TextStyle(color: Colors.green)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            leading: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFC4A4F4),
                              ),
                              child: Center(
                                child: Icon(
                                  LineAwesomeIcons.remove_user,
                                  color: Color(0xFF9A65EE),
                                ),
                              ),
                            ),
                            title: const Text(
                              'Desactivate Account',
                              style: TextStyle(color: Color(0xFFEF5259)),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          ProfileMenuWidget(
                            title: "Logout",
                            icon: LineAwesomeIcons.alternate_sign_out,
                            textColor: Colors.red,
                            endIcon: false,
                            onPress: () async {
                              final storage = FlutterSecureStorage();
                              await storage.delete(key: "token").then((_) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) =>
                                      false, // Remove all routes on the stack
                                );
                              }).catchError((error) {
                                print("Error occurred during logout: $error");
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(0xFFC2A3F7),
        ),
        child: Icon(
          icon,
          color: Color(0xFF8A4FE9),
        ),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyText1?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.lightPurple,
              ),
              child: const Icon(
                LineAwesomeIcons.angle_right,
                size: 18.0,
                color: Color(0xFF8A4FE9),
              ),
            )
          : null,
    );
  }
}
