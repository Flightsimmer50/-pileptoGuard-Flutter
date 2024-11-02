import 'package:epilepto_guard/Screens/MedicalSheet/medicalSheetFormScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';


class MedicalSheetScreen extends StatefulWidget {
  const MedicalSheetScreen({super.key});

  @override
  State<MedicalSheetScreen> createState() => _MedicalSheetScreenState();
}

class _MedicalSheetScreenState extends State<MedicalSheetScreen> {
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
    birthDate = await storage.read(key: "birthDate")?? " ";
    phoneNumber = await storage.read(key: "phoneNumber");
    weight = await storage.read(key: "weight")?? " ";
    height = await storage.read(key: "height")?? " ";

    // Set state to reflect the changes
    setState(() {});
  }

  
Future<void> _exportToPdf() async {
  final pdf = pw.Document();
  final String patientName = '$firstName $lastName';

  // Add content to the PDF document
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with patient's name
            pw.Container(
              alignment: pw.Alignment.center,
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Medical File',
                style: pw.TextStyle(
                  fontSize: 24.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Patient: $patientName',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            // Patient's information
            _buildPdfInfoRow('Birth Date', DateFormat('y-MM-dd').format(DateTime.parse(DateTime.parse(birthDate!).toString())) ?? ''),
            _buildPdfInfoRow('Tel', phoneNumber ?? ''),
            _buildPdfInfoRow('Weight', '$weight kg' ?? ''),
            _buildPdfInfoRow('Height', '$height cm' ?? ''),
            // Additional medical details
          /*  pw.Container(
              margin: pw.EdgeInsets.symmetric(vertical: 20.0),
              child: pw.Text(
                'Medical History:',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Brief medical history summary goes here...',
                style: pw.TextStyle(fontSize: 16.0),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Diagnosis:',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Diagnosis details go here...',
                style: pw.TextStyle(fontSize: 16.0),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Treatment Plan:',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Treatment plan details go here...',
                style: pw.TextStyle(fontSize: 16.0),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Prescriptions:',
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 20.0),
              child: pw.Text(
                'Prescription details go here...',
                style: pw.TextStyle(fontSize: 16.0),
              ),
            ),*/
          ],
        );
      }
    ),
  );

  // Get the directory for storing the PDF file
  String path;
  if (Platform.isAndroid) {
    final String downloadsDirectoryPath = (await getExternalStorageDirectory())!.path;
    path = '$downloadsDirectoryPath/medical_sheet_$firstName $lastName.pdf';
  } else if (Platform.isIOS) {
    final String documentsDirectoryPath = (await getApplicationDocumentsDirectory())!.path;
    path = '$documentsDirectoryPath/medical_sheet_$firstName $lastName.pdf';
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  // Save the PDF document to a file
  final file = File(path);
  await file.writeAsBytes(await pdf.save());
  print(path);
  await OpenFile.open(path);

  // Show a message indicating the file export is complete
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Medical file exported to PDF successfully.', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    ),
  );
}

pw.Widget _buildPdfInfoRow(String label, String value) {
  return pw.Container(
    margin: pw.EdgeInsets.symmetric(vertical: 8.0),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 100.0,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 18.0,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(width: 10.0),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Sheet',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        backgroundColor:
            const Color(0xFF8A4FE9), // Set background color to transparent
        elevation: 0, // Remove elevation shadow
        iconTheme:
            IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/background/send_code.png', // Replace 'background_image.jpg' with your actual image asset
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('First Name', firstName ?? ''),
                  _buildInfoRow('Last Name', lastName ?? ''),
                  _buildInfoRow('Birth Date', DateFormat('y-MM-dd').format(DateTime.parse(DateTime.parse(birthDate!).toString())) ?? ''),
                  _buildInfoRow('Phone Number', phoneNumber ?? ''),
                  _buildInfoRow('Weight', '$weight kg' ?? ''),
                  _buildInfoRow('Height', '$height cm' ?? ''),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add your export functionality here
                          _exportToPdf();
                      },
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ), // Icon for export
                      label: Text(
                        'Export Sheet',
                        style: TextStyle(color: Colors.white),
                      ), // Text for the button
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          // Set button shape to circular
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor:
                            const Color(0xFF8A4FE9), // Background color
                        disabledBackgroundColor:
                            Colors.white, // Foreground color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Theme(
        data: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFF8A4FE9), // Background color
            foregroundColor: Colors.white, // Icon color
            shape: RoundedRectangleBorder(
              // Make button circular
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Add your edit functionality here
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MedicalSheetFormScreen()));
          },
          child: Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8A4FE9),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
