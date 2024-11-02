import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:epilepto_guard/Models/sensor.dart';
import 'package:epilepto_guard/Services/sensorService.dart';
import 'package:epilepto_guard/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:epilepto_guard/Services/criseService.dart';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Models/seizure.dart';

import './DiscoveryPage.dart';

class MainPageBluetooth extends StatefulWidget {
  @override
  _MainPageBluetooth createState() => new _MainPageBluetooth();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _MainPageBluetooth extends State<MainPageBluetooth> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String BtWatchName = "DevDream-SmartWatch-BT";
  var connection; //BluetoothConnection
  List<_Message> messages = [];
  String _messageBuffer = '';

  bool isConnecting = true;
  bool isDisconnecting = false;

  bool isTrueSeizure = true; //False if false Seizure (if User swipe false)
  int seizureAlertCount = 0;
  BuildContext? _dialogContext;

  bool liveMonitoringEnabled;
  _MainPageBluetooth() : liveMonitoringEnabled = true;

  List<int> bpm = [];
  List<int> emg = [];
  List<int> imu = [];
  int counter = 0;

  late Seizure _newCrise;
  final storage = FlutterSecureStorage();

// Déclaration d'une variable pour stocker la localisation
  String currentLocation = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Request location permission
    Permission.location.request();

    // Request Bluetooth scan permission
    Permission.bluetoothScan.request();

    // Request Bluetooth connect permission
    Permission.bluetoothConnect.request();
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected()) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevDream Connectivity Settings'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: <Widget>[
            Divider(),
            Image.asset('assets/images/band.PNG'),
            Divider(),
            const ListTile(
              title: Text(
                'General',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Smartwatch device name'),
              subtitle: Text(BtWatchName),
            ),
            SwitchListTile(
              title: const Text('Enable Live Seizure Monitoring'),
              value: liveMonitoringEnabled,
              onChanged: (bool value) {
                setState(() {
                  liveMonitoringEnabled = value;
                  _sendMessage(value.toString());
                });
              },
            ),
            Divider(),
            ListTile(
              title: TextButton(
                  child: Text('Pair and connect to $BtWatchName'),
                  onPressed: () async {
                    final BluetoothDevice selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Discovery -> selected ' + selectedDevice.address);
                      _connectionSuccess(context, selectedDevice);
                    } else {
                      print('Discovery -> no device selected');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  // The code below will be executed after the connection to the bt device

  void _connectionSuccess(
      BuildContext context, BluetoothDevice selectedDevice) {
    final snackBar = SnackBar(
      content: Text("Successfully connected to ${selectedDevice.name}"),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    BluetoothConnection.toAddress(selectedDevice.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

// Ajoutez le print ici pour récupérer la position actuelle
      _getCurrentLocation();

      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });

    // Call the external method to send a message
  }

  void _getCurrentLocation() async {
    try {
      // Obtenez la position actuelle du téléphone
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Obtenez les détails d'emplacement à partir des coordonnées
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Obtenez l'adresse à partir des détails d'emplacement
      String location = placemarks[0].name ?? "Unknown";

      // Ajoutez un print pour afficher la localisation actuelle
      print('Current Location: $location');
    } catch (e) {
      print('Failed to get current location: $e');
    }
  }

  void _onDataReceived(Uint8List data) {
    String receivedData = utf8.decode(data);

    String dataWithoutPrefix = receivedData.substring(3);
    print("----------------------------");
    print("receivedData");
    print(receivedData);
    // print("counter");
    // print(counter);
    // print("bpm");
    // print(bpm);
    // print("emg");
    // print(emg);
    // print("imu");
    // print(imu);
    print("----------------------------");
    // Use switch-case to handle different types of messages
    if (receivedData.startsWith("emg")) {
      // for (String value in values) {
      //   // Parse the value to an integer and add it to the emg list
      //   emg.add(int.tryParse(value) ??
      //       0); // Use 0 as default value if parsing fails
      // }
    } else if (receivedData.startsWith("bmp")) {
      // for (String value in values) {
      //   bpm.add(int.tryParse(value) ??
      //       0); // Use 0 as default value if parsing fails
      // }
    } else if (receivedData.startsWith("imu")) {
      // for (String value in values) {
      //   imu.add(int.tryParse(value) ??
      //       0); // Use 0 as default value if parsing fails
      // }
      counter++;
    } else if (receivedData.startsWith("cri")) {
      if (seizureAlertCount == 0) {
        seizureAlertCount = 1;
        _alertCrise(context);
      }
      if (isTrueSeizure) {
        Future.delayed(Duration(seconds: 10), () {
          Navigator.of(_dialogContext!).pop(); // Close the dialog
          seizureAlertCount = 0;
          _addCrise();
        });
      }
      Future.delayed(Duration(seconds: 11), () {
        seizureAlertCount = 0;
        isTrueSeizure = true;
      });
    } else {
      print("message inconnu !");
    }

    if (counter > 5) {
      _addSensor();

      //reinitialise the values
      counter = 0;
      bpm = [];
      emg = [];
      imu = [];
    }
  }

  void _sendMessage(String text) async {
    try {
      connection.output.add(utf8.encode(text));
      await connection.output.allSent;
    } catch (e) {
      // Ignore error, but notify state
      setState(() {});
    }
  }

  bool isConnected() {
    return connection != null && connection.isConnected;
  }

  void _alertCrise(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogContext = context;
        return AlertDialog(
          title: Text('We detected a Seizure'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add the image here
              Image.asset(
                'assets/images/pls.gif',
                width: 300, // Adjust the width as needed
              ),
              const SizedBox(height: 16), // Add some spacing
              Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.up, // Allow swiping up to dismiss
                onDismissed: (_) {
                  // Handle swipe dismiss action
                  isTrueSeizure = false;
                  seizureAlertCount = 0;
                  Navigator.of(context).pop();
                },
                child: const Text('Swipe up to dismiss if false detection'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addCrise() async {
    try {
      String? userId = await storage.read(key: 'id');

      // Obtenez la position actuelle du téléphone
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

// Obtenez les détails d'emplacement à partir des coordonnées
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

// Obtenez l'adresse à partir des détails d'emplacement
      String location = placemarks[0].name ?? "Unknown";

      // Ajoutez un print pour afficher la localisation actuelle
      print('Current Location: $location');

      _newCrise = Seizure(
        userId: userId ?? "",
        date: DateTime.now().toString(),
        startTime: "09:00",
        endTime: "09:00",
        duration: 30,
        location: location,
        type: "generalized",
        emergencyServicesCalled: true,
        medicalAssistance: true,
        severity: "moderate",
      );
      print(_newCrise.toJson().toString());
      // print(location);
      await CriseService().createSeizure(_newCrise);
    } catch (e) {
      print('Failed to add Seizure: $e');
    }
  }

  Future<void> _addSensor() async {
    try {
      // Retrieve user ID from storage
      String? userId = await storage.read(key: 'id');

      // Create a new Sensor object with sensor data
      Sensor newSensor = Sensor(
        userId: userId ?? "",
        imu: imu,
        emg: emg,
        bmp: bpm,
      );

      // Print the sensor data for debugging
      print(newSensor.toJson());

      // Call the CriseService to add the sensor data
      await SensorService().postData(newSensor);
    } catch (e) {
      print('Failed to add sensor data: $e');
    }
  }
}
