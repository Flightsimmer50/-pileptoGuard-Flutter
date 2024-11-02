class PostCriseFormData {
  String idCrise; // id de la crise associée

  int selectedHours;
  int selectedMinutes;

  String? response1;

  bool? visualAuraChecked;
  bool? sensoryAuraChecked;
  bool? auditoryAuraChecked;
  bool? gustatoryOrOlfactoryAuraChecked;
  bool? headachesChecked;
  bool? excessiveFatigueChecked;
  bool? abnormalMoodChecked;
  bool? sleepDisturbancesChecked;
  bool? concentrationDifficultiesChecked;
  bool? increasedSensitivityChecked;

  List<bool>? triggerFactorsSelection;

  bool injured;
  double emotionalStateRating;
  double recoveryRating;
  bool medicationIntake;
  bool conscious;
  bool episodes;
  bool memoryDisturbances;
  double stressAnxietyRating;
  String? response2;
  bool assistance;
  double medicalCareRating;
  bool advice;
  String? response3;

  bool submitted;

  PostCriseFormData({
    required this.idCrise,
    required this.selectedHours,
    required this.selectedMinutes,
    this.response1,
    this.visualAuraChecked,
    this.sensoryAuraChecked,
    this.auditoryAuraChecked,
    this.gustatoryOrOlfactoryAuraChecked,
    this.headachesChecked,
    this.excessiveFatigueChecked,
    this.abnormalMoodChecked,
    this.sleepDisturbancesChecked,
    this.concentrationDifficultiesChecked,
    this.increasedSensitivityChecked,
    this.triggerFactorsSelection,
    required this.injured,
    required this.emotionalStateRating,
    required this.recoveryRating,
    required this.medicationIntake,
    required this.conscious,
    required this.episodes,
    required this.memoryDisturbances,
    required this.stressAnxietyRating,
    this.response2,
    required this.assistance,
    required this.medicalCareRating,
    required this.advice,
    this.response3,
    required this.submitted,
  });

  // Méthode pour sérialiser les données du formulaire
  Map<String, dynamic> toJson() {
    return {
      'criseId': idCrise,
      'selectedHours': selectedHours,
      'selectedMinutes': selectedMinutes,
      'response1': response1,
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
      'triggerFactorsSelection': triggerFactorsSelection,
      'injured': injured,
      'emotionalStateRating': emotionalStateRating,
      'recoveryRating': recoveryRating,
      'medicationIntake': medicationIntake,
      'conscious': conscious,
      'episodes': episodes,
      'memoryDisturbances': memoryDisturbances,
      'stressAnxietyRating': stressAnxietyRating,
      'response2': response2,
      'assistance': assistance,
      'medicalCareRating': medicalCareRating,
      'advice': advice,
      'response3': response3,
      'submitted': submitted,
    };
  }

  // Méthode pour désérialiser les données du formulaire
  factory PostCriseFormData.fromJson(Map<String, dynamic> json) {
    return PostCriseFormData(
      idCrise: json['criseId'],
      selectedHours: json['selectedHours'],
      selectedMinutes: json['selectedMinutes'],
      response1: json['response1'],
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
      triggerFactorsSelection: json['triggerFactorsSelection'] != null
          ? List<bool>.from(json['triggerFactorsSelection'])
          : [],
      injured: json['injured'],
      emotionalStateRating: json['emotionalStateRating'],
      recoveryRating: json['recoveryRating'],
      medicationIntake: json['medicationIntake'],
      conscious: json['conscious'],
      episodes: json['episodes'],
      memoryDisturbances: json['memoryDisturbances'],
      stressAnxietyRating: json['stressAnxietyRating'],
      response2: json['response2'],
      assistance: json['assistance'],
      medicalCareRating: json['medicalCareRating'],
      advice: json['advice'],
      response3: json['response3'],
      submitted: json['submitted'],
    );
  }
}
