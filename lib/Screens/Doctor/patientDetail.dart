import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Localization/language_constants.dart';
import '../../Models/patientsModel.dart';
import '../../Models/sensorModel.dart';
import '../../Services/doctorService.dart';
import '../../Utils/Constantes.dart';

class PatientDetail extends StatefulWidget {
  final PatientsModel patient;

  const PatientDetail({Key? key, required this.patient});

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  List<SensorModel> patientsData = [];
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _initPreferences();
    fetchPatients();
  }

  Future<void> _initPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> fetchPatients() async {
    try {
      var patients = await DoctorService().getSensorData();
      setState(() {
        patientsData = patients;
      });
    } catch (error) {
      print('Error getting sensor data: $error');
    }
  }

  List<LineChartBarData> emgData() {
    List<LineChartBarData> lineChartData = [];

    if (patientsData.isNotEmpty) {
      lineChartData.add(_buildLineChartBarData(
          data: patientsData
              .expand((e) => e.emg!)
              .map((e) => e.toDouble())
              .toList(),
          color: const Color(0xFFC987E1)));
    }
    return lineChartData;
  }

  LineChartBarData _buildLineChartBarData(
      {required List<double> data, required Color color}) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, "Patient's detail"),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:
            _darkMode ? const Color(0xFF301148) : const Color(0xFFC987E1),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _darkMode
                ? [const Color(0xFF4B0082), const Color(0xFF202020)]
                : [const Color(0xFFC2A3F7), const Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * .3,
                  width: MediaQuery.of(context).size.width * .85,
                  child: Center(
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        lineBarsData: emgData(),
                        titlesData: const FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 30),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                getTranslated(context, "EMG Signals Chart"),
                style: TextStyle(
                    color: _darkMode ? Colors.white : Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 16),
                child: Row(
                  children: [
                    Flexible(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            '${Constantes.USER_IMAGE_URL}/${widget.patient.image}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.patient.firstName} ${widget.patient.lastName}',
                            style: TextStyle(
                              color: _darkMode ? Colors.white : Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.patient.email ?? '',
                            style: TextStyle(
                              color: _darkMode ? Colors.white : Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.patient.phoneNumber.toString(),
                            style: TextStyle(
                              color: _darkMode ? Colors.white : Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
