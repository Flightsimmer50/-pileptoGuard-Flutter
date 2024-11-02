import 'package:epilepto_guard/Screens/User/verifCodeScreen.dart';
import 'package:epilepto_guard/Services/userWebService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerifEmailScreen extends StatefulWidget {
  const VerifEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifEmailScreen> createState() => _VerifEmailScreenState();
}

class _VerifEmailScreenState extends State<VerifEmailScreen> {
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
                          'assets/images/icons/email.png',
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Please enter your email address below to receive a verification code and reset your password.",
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                        ),
                        SizedBox(height: 15),
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
                        Container(
                          width: double.infinity, // Extends to both sides
                          child: ElevatedButton(
                            onPressed: () async {
                              // Add verif functionality
                              if (_formKey.currentState!.saveAndValidate()) {
                                
                              
                                bool success = await UserWebService().sendCode(
                                    _formKey.currentState!.value['email'],
                                    context);
                                if (success) {
                                    const storage = FlutterSecureStorage();
                                await storage.write(
                                    key: "resetEmail",
                                    value:
                                        _formKey.currentState!.value['email']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifCodeScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8A4FE9),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text('Send Code',
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
