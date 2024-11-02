import 'package:epilepto_guard/Models/userRole.dart';
import 'package:epilepto_guard/Screens/User/loginScreen.dart';
import 'package:epilepto_guard/Screens/homeScreen.dart';
import 'package:epilepto_guard/Services/userWebService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  UserRole _selectedRole = UserRole.patient;
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
              'assets/images/background/login.png', // Replace 'background_image.jpg' with your actual image asset
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
                          'assets/images/logo/epilepto_guard.png', // Replace 'logo.png' with your actual logo asset
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                        ),
                        const SizedBox(height: 10),
                        // First Name text field
                        FormBuilderTextField(
                          name: 'firstName',
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            } else if (value.length < 2) {
                              return 'First name must be at least 2 characters long';
                            } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                .hasMatch(value)) {
                              return 'First name can only contain letters and spaces';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Last Name text field
                        FormBuilderTextField(
                          name: 'lastName',
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            } else if (value.length < 2) {
                              return 'First name must be at least 2 characters long';
                            } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                .hasMatch(value)) {
                              return 'First name can only contain letters and spaces';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Role dropdown menu
                        DropdownButtonFormField<UserRole>(
                          value: _selectedRole,
                          onChanged: (UserRole? value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Role',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          items: UserRole.values
                              .map<DropdownMenuItem<UserRole>>((UserRole role) {
                            return DropdownMenuItem<UserRole>(
                              value: role,
                              child: Text(role
                                  .toString()
                                  .split('.')
                                  .last
                                  .replaceFirstMapped(
                                      RegExp(r'^\w'),
                                      (match) =>
                                          match.group(0)!.toUpperCase())),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Phone Number text field
                        FormBuilderTextField(
                          name: 'phoneNumber',
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length < 8) {
                              return 'Phone number must be at least 8 characters long';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Phone number can only contain numbers';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

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
                        const SizedBox(height: 20),

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
                                  _confirmpasswordVisible =
                                      !_confirmpasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 5) {
                              return 'Password must be at least 5 characters long';
                            } else if (value !=
                                _formKey
                                    .currentState!.fields['password']?.value) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Create Account button

                        Container(
                          width: double.infinity, // Extends to both sides
                          child: ElevatedButton(
                            onPressed: () {
                              // Add login functionality
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Role'),
                                      content: Text(
                                          'Are you sure you want to register as ${_selectedRole.toString().split('.').last} ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            // Proceed with registration
                                            UserWebService()
                                                .registerUser(
                                                  _formKey
                                                      .currentState!
                                                      .fields['firstName']!
                                                      .value
                                                      .toString(),
                                                  _formKey.currentState!
                                                      .fields['lastName']!.value
                                                      .toString(),
                                                  _formKey.currentState!
                                                      .fields['email']!.value
                                                      .toString(),
                                                  _formKey
                                                      .currentState!
                                                      .fields['phoneNumber']!
                                                      .value
                                                      .toString(),
                                                  _formKey.currentState!
                                                      .fields['password']!.value
                                                      .toString(),
                                                  _selectedRole
                                                      .toString()
                                                      .split('.')
                                                      .last,
                                                  context,
                                                )
                                                .then((value) => {
                                                      print("in then"),
                                                      print(value),
                                                      if (value)
                                                        {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Account created successfully',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const LoginScreen())),
                                                        }
                                                      else
                                                        {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Please correct the errors in the form.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          ),
                                                        }
                                                    });
                                          },
                                          child: const Text('Yes',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('No',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
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
                              backgroundColor: const Color(
                                  0xFF8A4FE9), // Set background color here
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      16.0), // Adjust button height as needed
                              child: Text('Create Account',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign In text link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                // Add sign In functionality
                                Navigator.of(context).pop(context);
                              },
                              child: const Text('Sign In',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Color(0xFF8A4FE9),
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
