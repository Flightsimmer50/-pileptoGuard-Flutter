import 'package:epilepto_guard/Services/userWebService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  final _formKey = GlobalKey<FormBuilderState>();

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
              'assets/images/background/send_code.png',
              fit: BoxFit.cover,
            ),

            // Centered logo and other content
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
                        'assets/images/icons/reset_password.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                      ),
                      SizedBox(height: 10),
                      const Text(
                        "Please enter your new password below.",
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                      SizedBox(height: 15),
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
                              return 'Please enter a new password';
                            } else if (value.length < 5) {
                              return 'Password must be at least 5 characters long';
                            }
                            return null;
                          },
                      ),
                      const SizedBox(height: 20),
                      // Password text field
                      FormBuilderTextField(
                        name: 'confirmPassword',
                        obscureText: !_confirmpasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          suffixIcon: IconButton(
                            icon: Icon(_confirmpasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _confirmpasswordVisible = !_confirmpasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != _formKey.currentState!.value['password']) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity, // Extends to both sides
                        child: ElevatedButton(
                          onPressed: () async {
                            // Add login functionality
                            if (_formKey.currentState!.saveAndValidate()) {
                              
                                const storage = FlutterSecureStorage();
                                var email =
                                    await storage.read(key: "resetEmail");

                              var success = await UserWebService().resetPassword(
                                  email!,
                                  _formKey.currentState!.value['password'],
                                  _formKey.currentState!.value['confirmPassword'],
                                  context);
                              if (success) {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              }
                            }else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.error, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                            'Please correct the errors in the form.',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8A4FE9),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text('Reset Password',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            ),
            // Back arrow button
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF8A4FE9)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor:
                    Colors.transparent, //You can make this transparent
                elevation: 0.0, //No shadow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
