import 'package:epilepto_guard/Screens/User/resetPasswordScreen.dart';
import 'package:epilepto_guard/Services/userWebService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerifCodeScreen extends StatefulWidget {
  const VerifCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerifCodeScreen> createState() => _VerifCodeScreenState();
}

class _VerifCodeScreenState extends State<VerifCodeScreen> {
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
                          'assets/images/icons/verify_code.png',
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                        ),
                        SizedBox(height: 10),
                        const Text(
                          "Please check your email and enter the verification code below.",
                          style: TextStyle(fontSize: 12.0, color: Colors.black),
                        ),
                        SizedBox(height: 15),
                        //  text field
                        FormBuilderTextField(
                          name: 'code',
                          decoration: InputDecoration(
                            hintText: 'Enter Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the code';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Code must be a number';
                            } else if (value.length != 4) {
                              return 'Code must be 4 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity, // Extends to both sides
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.saveAndValidate()) {
                               
                                // Add verif functionality
                                const storage = FlutterSecureStorage();
                                var email =
                                    await storage.read(key: "resetEmail");
                                var success = await UserWebService().verifyCode(
                                    email!,
                                    int.parse(
                                        _formKey.currentState!.value['code']),
                                    context);
                                if (success) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordScreen()));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8A4FE9),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text('Verify Code',
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
