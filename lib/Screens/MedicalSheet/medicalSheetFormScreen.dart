import 'package:epilepto_guard/Services/userWebService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class MedicalSheetFormScreen extends StatefulWidget {
  const MedicalSheetFormScreen({super.key});

  @override
  State<MedicalSheetFormScreen> createState() => _MedicalSheetFormScreenState();
}

class _MedicalSheetFormScreenState extends State<MedicalSheetFormScreen> {
  DateTime? selectedDate; // Define a variable to store the selected date
  String? dateOfBirth; // Define a variable to store the
  final _formKey = GlobalKey<FormBuilderState>();

  String? firstName;
  String? lastName;
  String? birthDate;
  String? phoneNumber;
  String? weight;
  String? height;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final storage = FlutterSecureStorage();

    // Use await to wait for the completion of each read operation
    firstName = await storage.read(key: "firstName");
    lastName = await storage.read(key: "lastName");
    birthDate = await storage.read(key: "birthDate");
    phoneNumber = await storage.read(key: "phoneNumber");
    weight = await storage.read(key: "weight");
    height = await storage.read(key: "height");

    // Set state to reflect the changes
    setState(() {
      print(firstName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medical Sheet Form',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        backgroundColor:
            const Color(0xFF8A4FE9), // Set background color to transparent
        elevation: 0, // Remove elevation shadow
        iconTheme:
            IconThemeData(color: Colors.white), // Set icon color to white
      ),
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
                        const SizedBox(height: 10),

                        // First Name text field
                        FormBuilderTextField(
                          name: 'firstName',
                          initialValue: firstName! ?? '',
                          enabled: false, 
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Last Name text field
                        FormBuilderTextField(
                          name: 'lastName',
                          initialValue: lastName! ?? '',
                          enabled: false, 
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'phoneNumber',
                          initialValue: phoneNumber! ?? '',
                          enabled: false, 
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email text field
                        TextFormField(
                          onTap: () async {
                            DateTime initialDate = birthDate != null ? DateTime.parse(birthDate!) : DateTime.now();

                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,

                              firstDate: DateTime(
                                  1900), // Set the first selectable date
                              lastDate: DateTime
                                  .now(), // Set the last selectable date (today)
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    // Customize the calendar theme
                                    primaryColor: const Color(
                                        0xFF8A4FE9), // Set primary color
                                    ///accentColor: const Color(0xFF8A4FE9), // Set accent color
                                    colorScheme: ColorScheme.light(
                                        primary: const Color(
                                            0xFF8A4FE9)), // Set color scheme
                                    buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme
                                          .primary, // Set button text theme
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null) {
                              // Check if picked date is not in the future
                              if (pickedDate.isBefore(DateTime.now())) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  dateOfBirth = DateFormat('y-MM-dd').format(
                                      selectedDate!); // Format the picked date
                                });
                              } else {
                                // Show error message if picked date is in the future
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Selected date cannot be in the future'),
                                  ),
                                );
                              }
                            } else {
                              
                                pickedDate = DateTime.parse(birthDate!);
                                selectedDate = pickedDate;
                                dateOfBirth = DateFormat('y-MM-dd').format(
                                    DateTime.parse(
                                        DateTime.parse(birthDate!).toString()));
                              
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Birth Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            suffixIcon: Icon(Icons
                                .calendar_today), // Add calendar icon as suffix
                          ),
                          readOnly: true, // Make the text field read-only
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                                : DateFormat('y-MM-dd').format(DateTime.parse(
                                    DateTime.parse(birthDate!)
                                        .toString())), // Set the text field value to the selected date
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'weight',
                          initialValue: weight! ?? '',
                          decoration: InputDecoration(
                            hintText: 'Weight',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            suffixText: 'kg',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            } else if (value.length < 2 || value.length > 3) {
                              return 'Weight must be 2 or 3 characters long';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'weight can only contain numbers';
                            }
                            return null;
                          },
                        ),
                        // Password text field
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'height',
                          initialValue: height! ?? '',
                          decoration: InputDecoration(
                            hintText: 'Height',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            suffixText: 'cm',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            } else if (value.length < 2 || value.length > 3) {
                              return 'height must be at least 3 characters long';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'height can only contain numbers';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Create Account button

                        Container(
                          width: double.infinity, // Extends to both sides
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                print(_formKey.currentState!.value);
                                print(dateOfBirth.toString());

                                //print(selectedDate!.toString());
                                const storage = FlutterSecureStorage();
                                var token = await storage.read(key: "token");
                                print(token);
                                await UserWebService().updateMedicalFile(
                                    dateOfBirth!,
                                    _formKey
                                        .currentState!.fields['weight']!.value,
                                    _formKey
                                        .currentState!.fields['height']!.value,
                                    token!,
                                    context);
                                    storage.write(key: "weight", value: _formKey
                                        .currentState!.fields['weight']!.value);
                                    storage.write(key: "height", value: _formKey
                                        .currentState!.fields['height']!.value);
                                    storage.write(key: "birthDate", value: DateTime.parse(dateOfBirth!).toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Medical file updated successfully',
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop(context);
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please correct the errors in the form.',
                                        style: TextStyle(color: Colors.white)),
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
                              child: Text('Update Sheet',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sign In text link
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
