import 'dart:convert';
import 'package:epilepto_guard/Models/dailyForm.dart';
import 'package:epilepto_guard/Services/dailyFormService.dart';
import 'package:epilepto_guard/Services/postFormService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:epilepto_guard/Utils/Constantes.dart';

class DailyFormDetailScreen extends StatefulWidget {
  // final String formDataId;
  final DailyForm dailyForm;
  final dailyFormService _dailyFormService = dailyFormService();

  //DailyFormDetailScreen({required this.formDataId});
  DailyFormDetailScreen({required this.dailyForm});

  @override
  _DailyFormDetailScreenState createState() => _DailyFormDetailScreenState();
}

class _DailyFormDetailScreenState extends State<DailyFormDetailScreen> {
  late DailyForm formData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // _fetchFormData();
    formData = widget.dailyForm;
    isLoading = false;
  }

  Future<void> _fetchFormData() async {
    try {
      final fetchedFormData = await widget._dailyFormService
          .fetchFormData(widget.dailyForm as String);
      setState(() {
        formData = fetchedFormData!;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching form data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Daily Form Details',
          style: TextStyle(
            color: const Color(0xFF8A4FE9),
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem(
                      'Bed Time:',
                      '${formData.formattedTime(formData.bedTime)}',
                    ),
                    _buildDetailItem(
                      'Wake Up Time:',
                      '${formData.formattedTime(formData.wakeUpTime)}',
                    ),
                    _buildDetailItem(
                      'Stress Rating:',
                      formData.stress.toString(),
                    ),
                    _buildDetailItem(
                      'Alcohol/Drug Rating:',
                      formData.alcoholDrug.toString(),
                    ),
                    _buildDetailItem(
                      'Medication Taken:',
                      formData.medication != null
                          ? formData.medication!
                              ? 'Yes'
                              : 'No'
                          : '',
                    ),
                    _buildDetailItem(
                      'Mood Changes Rating:',
                      formData.moodchanges.toString(),
                    ),
                    _buildDetailItem(
                      'Sleeping Rating:',
                      formData.sleeping != null
                          ? formData.sleeping.toString()
                          : '',
                    ),
                    _buildDetailItem(
                      'Flashing Lights Rating:',
                      formData.flashingLights != null
                          ? formData.flashingLights.toString()
                          : '',
                    ),
                    _buildDetailItem(
                      'Exercise Rating:',
                      formData.exercise != null
                          ? formData.exercise.toString()
                          : '',
                    ),
                    _buildDetailItem(
                      'Meal/Sleep No Value:',
                      formData.mealSleepNoValue,
                    ),
                    _buildDetailItem(
                      'Recent Changes:',
                      formData.recentChanges != null
                          ? formData.recentChanges!
                          : '',
                    ),
                    _buildDetailItem(
                      'Visual Aura Checked:',
                      formData.visualAuraChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Sensory Aura Checked:',
                      formData.sensoryAuraChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Auditory Aura Checked:',
                      formData.auditoryAuraChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Gustatory/Olfactory Aura Checked:',
                      formData.gustatoryOrOlfactoryAuraChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Headaches Checked:',
                      formData.headachesChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Excessive Fatigue Checked:',
                      formData.excessiveFatigueChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Abnormal Mood Checked:',
                      formData.abnormalMoodChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Sleep Disturbances Checked:',
                      formData.sleepDisturbancesChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Concentration Difficulties Checked:',
                      formData.concentrationDifficultiesChecked ? 'Yes' : 'No',
                    ),
                    _buildDetailItem(
                      'Increased Sensitivity Checked:',
                      formData.increasedSensitivityChecked ? 'Yes' : 'No',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160.0, // Maximum width of the label
            padding: EdgeInsets.all(10.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8A4FE9),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                value,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
