import 'dart:convert';

import 'package:epilepto_guard/Models/postCriseForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum CrisisType {
  partial,
  generalized,
  absence,
}

class Crisis {
  final String idCrise;
  final String userId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int duration;
  final String location;
  final CrisisType type;
  final bool emergencyServicesCalled;
  final bool medicalAssistance;
  final String severity;
  final String formDataId; //l'id du formulaire de crise

  Crisis({
    required this.idCrise,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.type,
    required this.location,
    required this.emergencyServicesCalled,
    required this.medicalAssistance,
    required this.severity,
    required this.formDataId,
  });

  // Méthode pour désérialiser un objet JSON en instance de Crisis
  factory Crisis.fromJson(Map<String, dynamic> json) {
    return Crisis(
      idCrise: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      startTime: _parseTimeOfDay(json['startTime'] ?? ''),
      endTime: _parseTimeOfDay(json['endTime'] ?? ''),
      duration: json['duration'] ?? 0,
      location: json['location'] ?? '',
      type: CrisisType.values.firstWhere(
          (type) => type.toString() == 'CrisisType.${json['type']}'),
      emergencyServicesCalled: json['emergencyServicesCalled'] ?? false,
      medicalAssistance: json['medicalAssistance'] ?? false,
      severity: json['severity'] ?? '',
      formDataId: json['formDataId'] ?? '',
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
