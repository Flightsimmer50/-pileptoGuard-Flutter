import 'package:epilepto_guard/Screens/Admin/userList.dart';
import 'package:epilepto_guard/Screens/Doctor/patientDetail.dart';
import 'package:epilepto_guard/Screens/Doctor/patientsList.dart';
import 'package:epilepto_guard/Screens/User/registerScreen.dart';
import 'package:epilepto_guard/Screens/User/verifEmailScreen.dart';
import 'package:epilepto_guard/Services/userWebService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormBuilderState>();
  final _googleSignIn = GoogleSignIn(
    clientId:
        '485905293101-t2vlph7ob8tpotsmnofgo1qi19dusi58.apps.googleusercontent.com',
    scopes: <String>['email', 'profile', 'openid'],
  );

  @override
  void initState() {
    final _googleSignIn = GoogleSignIn(
      clientId:
          '485905293101-aah8f4uhq456u7aqdl2s7gmbuq7lo32s.apps.googleusercontent.com',
      scopes: <String>['email', 'profile', 'openid'],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent keyboard resizing issues
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/background/login.png',
              // Replace 'background_image.jpg' with your actual image asset
              fit: BoxFit.cover,
            ),
            // Centered logo
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo/epilepto_guard.png',
                          // Replace 'logo.png' with your actual logo asset
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                        ),
                        SizedBox(height: 10),
                        // Email text field
                        FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Password text field
                        FormBuilderTextField(
                          name: 'password',
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Remember Me checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                              // Customize the color of the checkbox
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Color(
                                        0xFF8A4FE9); // Selected color
                                  }
                                  return Colors.white; // Unselected color
                                },
                              ),
                            ),
                            // Customize the color of the text
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                color: const Color(0xFF8A4FE9),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),
                        // Login button

                        Container(
                          width: double.infinity, // Extends to both sides
                          child: ElevatedButton(
                            onPressed: () async {
                              // Add login functionality
                              if (_formKey.currentState!.saveAndValidate()) {
                                final email =
                                    _formKey.currentState!.value['email'];
                                final password =
                                    _formKey.currentState!.value['password'];

                                // Check the state of the "Remember Me" checkbox
                                if (_rememberMe) {
                                  // Save user's email and password to secure storage
                                  final storage = FlutterSecureStorage();
                                  await storage.write(
                                      key: 'email', value: email);
                                  await storage.write(
                                      key: 'password', value: password);
                                } else {
                                  // Clear saved user's email and password
                                  final storage = FlutterSecureStorage();
                                  await storage.delete(key: 'email');
                                  await storage.delete(key: 'password');
                                }

                                // Proceed with login
                                UserWebService()
                                    .login(context, email, password)
                                    .then((value) async {
                                  print(value);
                                  if (value == 'patient') {
                                    // Navigate to home screen after successful login
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  } else if (value == 'doctor') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PatientsList()));
                                  } else if (value == 'admin') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => UserList()));
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF8A4FE9), // Set background color here
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      16.0), // Adjust button height as needed
                              child: Text('Log in',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white)),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        // Forgot password text link
                        TextButton(
                          onPressed: () {
                            // Add forgot password functionality
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VerifEmailScreen()));
                          },
                          child: Text('Forgot password?',
                              style: TextStyle(
                                color: const Color(0xFF8A4FE9),
                              )),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "-Or sign in with-",
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                final creds = await _googleSignIn.signIn();
                                if (creds == null) {
                                  debugPrint('Could not Sign in');
                                } else {
                                  debugPrint('Signed in Successfully');
                                  print(creds.email);
                                  final googleKey = await creds.authentication;

                                  FlutterSecureStorage().write(
                                    key: 'token',
                                    value: googleKey.accessToken,
                                  );

                                  final fullName = creds.displayName;
                                  final List<String> parts =
                                      fullName!.split(' ');
                                  String firstName = '';
                                  String lastName = '';

                                  if (parts.isNotEmpty) {
                                    firstName = parts.first;

                                    if (parts.length > 1) {
                                      lastName = parts.sublist(1).join(' ');
                                    }
                                  }
                                  FlutterSecureStorage()
                                      .write(key: 'email', value: creds.email);
                                  FlutterSecureStorage().write(
                                      key: 'firstName', value: firstName);
                                  FlutterSecureStorage()
                                      .write(key: 'lastName', value: lastName);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Image.asset(
                                      'assets/images/logo/Google.png',
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("Sign In with Google"),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        // Sign up text link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                // Add sign up functionality
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                              },
                              child: Text('Sign up',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: const Color(0xFF8A4FE9),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
