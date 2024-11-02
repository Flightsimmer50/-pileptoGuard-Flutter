import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:epilepto_guard/Screens/Drugs/ListDrug.dart';
import 'package:epilepto_guard/models/drug.dart';
import 'package:epilepto_guard/services/drugService.dart';

class UpdateMedicineScreen extends StatefulWidget {
  const UpdateMedicineScreen({Key? key}) : super(key: key);

  @override
  _UpdateMedicineScreenState createState() => _UpdateMedicineScreenState();
}

class _UpdateMedicineScreenState extends State<UpdateMedicineScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedStartTakingDate;
  DateTime? _selectedEndTakingDate;
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

  Future<void> _pickImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
        _newDrug.image = pickedImage.path;
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
        _newDrug.startTakingDate = pickedDate;
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
        _newDrug.endTakingDate = pickedDate;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Drug updated successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListDrug()),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String startDateText = _selectedStartTakingDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedStartTakingDate!)
        : 'Start Date';
    String endDateText = _selectedEndTakingDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedEndTakingDate!)
        : 'End Date';

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Drug'),
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
                          startDateText,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        onPressed: _selectEndTakingDate,
                        child: Text(
                          endDateText,
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
                  items: [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5'
                  ], // Example items, change as needed

                  onChanged: (value) {
                    setState(() {
                      _newDrug.quantityPerTake = int.tryParse(value ?? '');
                    });
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await DrugService().updateDrug(_newDrug.name, _newDrug);
                              _showSuccessDialog(); // Show success dialog
                            } catch (e) {
                              print('Failed to update drug: $e');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A4FE9),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Update',
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
}

class AnimatedTextField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const AnimatedTextField({
    Key? key,
    required this.hintText,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: _isFocused ? Colors.white : Colors.white.withOpacity(0.7),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          if (value.isEmpty) {
            setState(() {
              _isFocused = false;
            });
          }
        },
        onFieldSubmitted: (value) {
          setState(() {
            _isFocused = false;
          });
        },
        validator: widget.validator,
      ),
    );
  }
}

class AnimatedDropdownFormField extends StatefulWidget {
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
  _AnimatedDropdownFormFieldState createState() =>
      _AnimatedDropdownFormFieldState();
}

class _AnimatedDropdownFormFieldState extends State<AnimatedDropdownFormField> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: _selectedItem != null
            ? Colors.white
            : Colors.white.withOpacity(0.7),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
        value: _selectedItem,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedItem = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
      ),
    );
  }
}
