class Seizure {
  final String userId;
  final String date;
  final String startTime;
  final String endTime;
  final int duration;
  final String location;
  final String type;
  final bool emergencyServicesCalled;
  final bool? medicalAssistance;
  final String severity;

  Seizure({
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.location,
    required this.type,
    required this.emergencyServicesCalled,
    this.medicalAssistance,
    required this.severity,
  });

  factory Seizure.fromJson(Map<String, dynamic> json) {
    return Seizure(
      userId: json['userId'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
      location: json['location'],
      type: json['type'],
      emergencyServicesCalled: json['emergencyServicesCalled'],
      medicalAssistance: json['medicalAssistance'],
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'location': location,
      'type': type,
      'emergencyServicesCalled': emergencyServicesCalled,
      'medicalAssistance': medicalAssistance,
      'severity': severity,
    };
  }
}
