import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:epilepto_guard/Screens/Drugs/ListDrug.dart';
import 'package:epilepto_guard/models/drug.dart';
import 'package:epilepto_guard/services/drugService.dart';
import 'package:http/http.dart' as http;

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({Key? key}) : super(key: key);

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedStartTakingDate;
  DateTime? _selectedEndTakingDate;
  TimeOfDay? _selectedTime;
  XFile? _selectedImage;
  Drug _newDrug = Drug(
    name: '',
    description: '',
    startTakingDate: DateTime.now(),
    endTakingDate: DateTime.now(),
    dayOfWeek: '',
    image: '',
    numberOfTimeADay: '',
    quantityPerTake: null,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Drug'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.upload),
                  label: Text('Upload Image'),
                  
                ),
                SizedBox(height: 20),
                _selectedImage != null
                    ? Text(
                        'Selected Image: ${_selectedImage!.path}',
                        style: TextStyle(fontSize: 16),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 20),
                AnimatedTextField(
                  hintText: 'Name',
                  onChanged: (value) {
                    setState(() {
                      _newDrug.name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                AnimatedTextField(
                  hintText: 'Description',
                  onChanged: (value) {
                    setState(() {
                      _newDrug.description = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _selectStartTakingDate,
                        child: Text(
                          _selectedStartTakingDate != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(_selectedStartTakingDate!)
                              : 'Start Date',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        onPressed: _selectEndTakingDate,
                        child: Text(
                          _selectedEndTakingDate != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(_selectedEndTakingDate!)
                              : 'End Date',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AnimatedTextField(
                  hintText: 'Day Of Week',
                  onChanged: (value) {
                    setState(() {
                      _newDrug.dayOfWeek = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Day of Week cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                AnimatedTextField(
                  hintText: 'Number Of Time A Day',
                  onChanged: (value) {
                    setState(() {
                      _newDrug.numberOfTimeADay = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of Time a Day cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                AnimatedDropdownFormField(
                  hintText: 'Quantity Per Take',
                  items: ['1', '2', '3', '4', '5'],
                  onChanged: (value) {
                    setState(() {
                      _newDrug.quantityPerTake = int.tryParse(value ?? '');
                    });
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A4FE9),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Future<void> _pickImage() async {
  XFile? pickedImage = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  if (pickedImage != null) {
    setState(() {
      _selectedImage = pickedImage;
      _newDrug.image = pickedImage.path; // Mettre à jour le chemin de l'image dans _newDrug.image
    });
  }
}

 Future<void> _selectStartTakingDate() async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedStartTakingDate ?? DateTime.now(),
    firstDate: DateTime(2022),
    lastDate: DateTime(2030),
  );

  if (pickedDate != null) {
    setState(() {
      _selectedStartTakingDate = pickedDate;
      _newDrug.startTakingDate = pickedDate; // Met à jour la valeur de _newDrug.startTakingDate
    });
  }
}


  Future<void> _selectEndTakingDate() async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedEndTakingDate ?? DateTime.now(),
    firstDate: DateTime(2022),
    lastDate: DateTime(2030),
  );

  if (pickedDate != null) {
    setState(() {
      _selectedEndTakingDate = pickedDate;
      _newDrug.endTakingDate = pickedDate; // Met à jour la valeur de _newDrug.endTakingDate
    });
  }
}


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is validated, add drug
      _formKey.currentState!.save(); // Save form data
      _addDrug();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Drug added successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                Navigator.of(context).pop(); // Ferme l'écran actuel
                Navigator.push( // Navigue vers ListDrug
                  context,
                  MaterialPageRoute(builder: (context) => ListDrug()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addDrug() async {
    try {
      await DrugService().addDrug(_newDrug);
      _showSuccessDialog();
    } catch (e) {
      print('Failed to add drug: $e');
    }
  }
}

class AnimatedTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    Key? key,
    required this.hintText,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white.withOpacity(0.7),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class AnimatedDropdownFormField extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const AnimatedDropdownFormField({
    Key? key,
    required this.hintText,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white.withOpacity(0.7),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
        value: null,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
