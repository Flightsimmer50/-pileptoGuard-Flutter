import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyForm {
  String id;
  String userId;
  Map<String, int> bedTime;
  Map<String, int> wakeUpTime;
  double stress;
  double alcoholDrug;
  bool? medication;
  double moodchanges;
  double? sleeping;
  double? flashingLights;
  double? exercise;
  String mealSleepNoValue;
  String? recentChanges;
  bool visualAuraChecked;
  bool sensoryAuraChecked;
  bool auditoryAuraChecked;
  bool gustatoryOrOlfactoryAuraChecked;
  bool headachesChecked;
  bool excessiveFatigueChecked;
  bool abnormalMoodChecked;
  bool sleepDisturbancesChecked;
  bool concentrationDifficultiesChecked;
  bool increasedSensitivityChecked;
  DateTime createdAt;
  bool isArchived;

  DailyForm(
      {required this.id,
      required this.userId,
      required this.bedTime,
      required this.wakeUpTime,
      required this.stress,
      required this.alcoholDrug,
      this.medication,
      required this.moodchanges,
      this.sleeping,
      this.flashingLights,
      this.exercise,
      required this.mealSleepNoValue,
      required this.recentChanges,
      required this.visualAuraChecked,
      required this.sensoryAuraChecked,
      required this.auditoryAuraChecked,
      required this.gustatoryOrOlfactoryAuraChecked,
      required this.headachesChecked,
      required this.excessiveFatigueChecked,
      required this.abnormalMoodChecked,
      required this.sleepDisturbancesChecked,
      required this.concentrationDifficultiesChecked,
      required this.increasedSensitivityChecked,
      required this.createdAt,
      required this.isArchived});

  // Méthode pour sérialiser les données du formulaire
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'bedTime': {'hour': bedTime['hour'], 'minute': bedTime['minute']},
      'wakeUpTime': {
        'hour': wakeUpTime['hour'],
        'minute': wakeUpTime['minute']
      },
      'stress': stress,
      'alcoholDrug': alcoholDrug,
      'medication': medication,
      'moodchanges': moodchanges,
      'sleeping': sleeping,
      'flashingLights': flashingLights,
      'exercise': exercise,
      'mealSleepNoValue': mealSleepNoValue,
      'recentChanges': recentChanges,
      'visualAuraChecked': visualAuraChecked,
      'sensoryAuraChecked': sensoryAuraChecked,
      'auditoryAuraChecked': auditoryAuraChecked,
      'gustatoryOrOlfactoryAuraChecked': gustatoryOrOlfactoryAuraChecked,
      'headachesChecked': headachesChecked,
      'excessiveFatigueChecked': excessiveFatigueChecked,
      'abnormalMoodChecked': abnormalMoodChecked,
      'sleepDisturbancesChecked': sleepDisturbancesChecked,
      'concentrationDifficultiesChecked': concentrationDifficultiesChecked,
      'increasedSensitivityChecked': increasedSensitivityChecked,
      'createdAt': DateFormat('yyyy-MM-dd').format(createdAt),
      'isArchived': isArchived,
    };
  }

  // Méthode pour désérialiser les données du formulaire
  factory DailyForm.fromJson(Map<String, dynamic> json) {
    return DailyForm(
      id: json['_id'],
      userId: json['userId'],
      bedTime: {
        'hour': json['bedTime']['hour'],
        'minute': json['bedTime']['minute']
      },
      wakeUpTime: {
        'hour': json['wakeUpTime']['hour'],
        'minute': json['wakeUpTime']['minute']
      },
      stress: json['stress'],
      alcoholDrug: json['alcoholDrug'],
      medication: json['medication'],
      moodchanges: json['moodchanges'],
      sleeping: json['sleeping'],
      flashingLights: json['flashingLights'],
      exercise: json['exercise'],
      mealSleepNoValue: json['mealSleepNoValue'],
      recentChanges: json['recentChanges'],
      visualAuraChecked: json['visualAuraChecked'],
      sensoryAuraChecked: json['sensoryAuraChecked'],
      auditoryAuraChecked: json['auditoryAuraChecked'],
      gustatoryOrOlfactoryAuraChecked: json['gustatoryOrOlfactoryAuraChecked'],
      headachesChecked: json['headachesChecked'],
      excessiveFatigueChecked: json['excessiveFatigueChecked'],
      abnormalMoodChecked: json['abnormalMoodChecked'],
      sleepDisturbancesChecked: json['sleepDisturbancesChecked'],
      concentrationDifficultiesChecked:
          json['concentrationDifficultiesChecked'],
      increasedSensitivityChecked: json['increasedSensitivityChecked'],
      createdAt: DateTime.parse(json['createdAt']),
      isArchived: json['isArchived'],
    );
  }

  // Méthode pour convertir une String au format HH:mm en TimeOfDay
  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

// Méthode pour formater l'heure au format HH:mm
  String formattedTime(Map<String, int> time) {
    final timeOfDay = _parseTime('${time['hour']}:${time['minute']}');
    final formatted = DateFormat.Hm()
        .format(DateTime(2022, 1, 1, timeOfDay.hour, timeOfDay.minute));
    return formatted;
  }

// Méthode pour formater la date en "DD/MM/YYYY"
  String formatCreatedAt() {
    return DateFormat('dd/MM/yyyy').format(createdAt);
  }
}
