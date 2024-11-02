import 'package:epilepto_guard/Models/dailyForm.dart';
import 'package:epilepto_guard/Models/postCriseForm.dart';
import 'package:epilepto_guard/Services/dailyFormService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class FormulaireQuotidien extends StatefulWidget {
  final String id;
  //final dailyFormService dailyFormService;
  const FormulaireQuotidien({Key? key, required this.id}) : super(key: key);
  @override
  _FormulaireQuotidienState createState() => _FormulaireQuotidienState();
}

class _FormulaireQuotidienState extends State<FormulaireQuotidien> {
  // Ajoutez une clé globale pour accéder au Scaffold depuis la méthode _saveForm
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String _id;

  TimeOfDay _bedTime = TimeOfDay.now();
  TimeOfDay _wakeUpTime = TimeOfDay.now();

  // rate variable
  double _stressRating = 0;
  double _alcoholDrugRating = 0;
  double _moodchangesRating = 0;
  double _sleepingRating = 0;
  double _flashingLightsRating = 0;
  double _exerciseRating = 0;
  bool _takenMedicationsAsPrescribed = false;
  String _mealSleepNoValue = '';
  //Variables a cocher pour la derniere question (13)
  bool _visualAuraChecked = false;
  bool _sensoryAuraChecked = false;
  bool _auditoryAuraChecked = false;
  bool _gustatoryOrOlfactoryAuraChecked = false;
  bool _headachesChecked = false;
  bool _excessiveFatigueChecked = false;
  bool _abnormalMoodChecked = false;
  bool _sleepDisturbancesChecked = false;
  bool _concentrationDifficultiesChecked = false;
  bool _increasedSensitivityChecked = false;
  bool _isArchived = false;
  bool isNewDay = false;

  //text field area
  TextEditingController? _recentChangesController;

  // Déclarez une instance du service dailyFormService
  final dailyFormService _dailyFormService = dailyFormService();

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _stressRating = 0;
    _alcoholDrugRating = 0;
    _moodchangesRating = 0;
    _sleepingRating = 0;
    _flashingLightsRating = 0;
    _exerciseRating = 0;

    _recentChangesController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Daily Questionnaire',
          style: TextStyle(
            color: const Color(0xFF8A4FE9),
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        //******************* 1 ***************************************************
        child: ListView(
          children: [
            // Contrôle de saisie "New day"
            CheckboxListTile(
              title: Text(
                  'Check this box if the bedtime and wake-up time are not on the same day.'),
              value: isNewDay,
              onChanged: _handleNewDay,
              activeColor: Color(0xFF8A4FE9),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'What time did you \ngo to bed last night?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      _selectBedTime(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 10),
                          Text(
                            '${_bedTime.hour}:${_bedTime.minute}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //************************* 2 *********************************/
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'When did you \nwoke up today ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      _selectWakeUpTime(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 10),
                          Text(
                            '${_wakeUpTime.hour}:${_wakeUpTime.minute}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //********** 3 (rate) ****************************************
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Were you exposed to sources of stress yesterday ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: _stressRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: const Color(0xFF8A4FE9),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _stressRating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
//************ 4 ************************************************************ */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you consumed alcohol or drugs recently ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: _alcoholDrugRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: const Color(0xFF8A4FE9),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _alcoholDrugRating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
//********** *********** 5 *******************************************************/
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you taken all your antiepileptic medications as prescribed ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Yes',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Radio<bool>(
                        value: true,
                        groupValue: _takenMedicationsAsPrescribed,
                        onChanged: (bool? value) {
                          setState(() {
                            _takenMedicationsAsPrescribed = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                      Text(
                        'No',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Radio<bool>(
                        value: false,
                        groupValue: _takenMedicationsAsPrescribed,
                        onChanged: (bool? value) {
                          setState(() {
                            _takenMedicationsAsPrescribed = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
//******************************** 6 *************************************** */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you noticed any changes in your mood or level of anxiety recently ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: _moodchangesRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: const Color(0xFF8A4FE9),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _moodchangesRating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
//********************  7 ************************************************* */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you experienced difficulty sleeping recently ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: _sleepingRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: const Color(0xFF8A4FE9),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _sleepingRating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
//************************************** 8 ******************************** */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you been exposed to flashing lights or intense visual stimulation ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: _flashingLightsRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: const Color(0xFF8A4FE9),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _flashingLightsRating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
//************************** 9 ********************************************* */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you engaged in exercise or intense physical activity recently?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: _exerciseRating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: const Color(0xFF8A4FE9),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _exerciseRating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
//***********************  10 ****************************************************** */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you missed meals or sleep periods recently ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Meals',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Radio<String>(
                        value: 'Meals',
                        groupValue: _mealSleepNoValue,
                        onChanged: (String? value) {
                          setState(() {
                            _mealSleepNoValue = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                      Text(
                        'Sleep',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Radio<String>(
                        value: 'Sleep',
                        groupValue: _mealSleepNoValue,
                        onChanged: (String? value) {
                          setState(() {
                            _mealSleepNoValue = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                      Text(
                        'No',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Radio<String>(
                        value: 'No',
                        groupValue: _mealSleepNoValue,
                        onChanged: (String? value) {
                          setState(() {
                            _mealSleepNoValue = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
//*******************************11******************************** */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you had any recent changes in your work or study schedule ?',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _recentChangesController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Answer...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
//************************12****************************** */
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Have you experienced prodromal symptoms before previous seizures?',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 35),
                  // Première option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Visual Aura: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Visual changes such as flashing lights, blind spots, or flickering.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _visualAuraChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _visualAuraChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Deuxième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sensory Aura: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Unusual sensations such as tingling, numbness, or burning sensations in certain parts of the body.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _sensoryAuraChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _sensoryAuraChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Troisième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Auditory Aura: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Unusual sounds such as buzzing, ringing, or auditory hallucinations.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _auditoryAuraChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _auditoryAuraChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Quatrième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Gustatory or Olfactory Aura: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Abnormal or unpleasant tastes or smells that are not present in the environment.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _gustatoryOrOlfactoryAuraChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _gustatoryOrOlfactoryAuraChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Cinquième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Headaches: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Headaches often described as severe or throbbing.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _headachesChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _headachesChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Sixième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Excessive Fatigue: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Feelings of extreme fatigue or unusual exhaustion.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _excessiveFatigueChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _excessiveFatigueChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Septième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Abnormal Mood: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Mood changes such as anxiety, depression, or irritability.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _abnormalMoodChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _abnormalMoodChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Huitième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sleep Disturbances: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Difficulty falling asleep, restless sleep, or insomnia.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _sleepDisturbancesChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _sleepDisturbancesChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Neuvième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Concentration Difficulties: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Problems with concentration or memory, feeling of confusion or disorientation.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _concentrationDifficultiesChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _concentrationDifficultiesChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Dixième option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Increased Sensitivity: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Excessive sensitivity to light, sound, or sensory stimuli.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _increasedSensitivityChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _increasedSensitivityChecked = value!;
                          });
                        },
                        activeColor: const Color(0xFF8A4FE9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
//************************************************************************************ */
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
                // print(
                // 'Took medications as prescribed: $_takenMedicationsAsPrescribed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF8A4FE9), // Définir la couleur de fond ici
                padding: EdgeInsets.symmetric(
                    vertical: 16.0), // Ajuster la hauteur du bouton ici
              ),
              child: Text(
                'Save Form',
                style: TextStyle(
                  color: Colors.white, // Définir la couleur du texte en blanc
                  fontSize: 18.0, // Ajuster la taille du texte ici
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Méthode pour afficher la boîte de dialogue de confirmation
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to save the form?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                _saveForm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// fonction pour gérer l'action lorsque le bouton "Save" est pressé
  void _saveForm() async {
    try {
      // Vérifier si les heures de réveil et de coucher sont valides
      if (_bedTime != null && _wakeUpTime != null) {
        // Convertir TimeOfDay en DateTime pour la comparaison
        DateTime bedDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _bedTime.hour,
          _bedTime.minute,
        );
        DateTime wakeUpDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _wakeUpTime.hour,
          _wakeUpTime.minute,
        );
        if (wakeUpDateTime.isBefore(bedDateTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Wake Up time cannot be before Bedtime',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
      } else {
        // Les heures ne sont pas sélectionnées
        // Afficher une alerte ou un SnackBar pour informer l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select Bedtime and Wake Up time',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return; // Arrêter l'exécution de la fonction
      }
      // Récupérer les valeurs des champs texte de manière sécurisée
      String recentChanges = _recentChangesController?.text ?? '';

      bool submitted = true;
      final storage = FlutterSecureStorage();

      String? loadedid = await storage.read(key: "id");

      // Obtenir la date actuelle au format DateTime
      DateTime now = DateTime.now();
      // Formater la date au format "DD/MM/YYYY"
      String formattedDate = DateFormat('dd/MM/yyyy').format(now);

      // Créer une instance de PostCriseFormData
      DailyForm formData = DailyForm(
        id: _id,
        userId: loadedid!,
        bedTime: {
          'hour': _bedTime.hour,
          'minute': _bedTime.minute,
        },
        wakeUpTime: {
          'hour': _wakeUpTime.hour,
          'minute': _wakeUpTime.minute,
        },
        stress: _stressRating,
        alcoholDrug: _alcoholDrugRating,
        medication: _takenMedicationsAsPrescribed,
        moodchanges: _moodchangesRating,
        sleeping: _sleepingRating,
        flashingLights: _flashingLightsRating,
        exercise: _exerciseRating,
        mealSleepNoValue: _mealSleepNoValue,
        recentChanges: recentChanges,

        //a chocher
        visualAuraChecked: _visualAuraChecked,
        sensoryAuraChecked: _sensoryAuraChecked,
        auditoryAuraChecked: _auditoryAuraChecked,
        gustatoryOrOlfactoryAuraChecked: _gustatoryOrOlfactoryAuraChecked,
        headachesChecked: _headachesChecked,
        excessiveFatigueChecked: _excessiveFatigueChecked,
        abnormalMoodChecked: _abnormalMoodChecked,
        sleepDisturbancesChecked: _sleepDisturbancesChecked,
        concentrationDifficultiesChecked: _concentrationDifficultiesChecked,
        increasedSensitivityChecked: _increasedSensitivityChecked,
        isArchived: _isArchived,

        // Ajouter la date de création
        createdAt: now,
      );
      //  print("form Data :" + formData.toJson().toString());
      _dailyFormService.sendDataToBackend2(formData);
      // Mise à jour de isFormSubmitted après l'envoi du formulaire
      // _checkIfFormSubmitted();

      // Afficher le SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your form is successfully saved, you can review it by visiting the history in your profile',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF8A4FE9),
          duration: Duration(seconds: 5),
        ),
      );

      // Revenir à la page précédente
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      // Gérer les erreurs
      print('Erreur lors de l\'enregistrement du formulaire: $e');
      print(stackTrace);
    }
  }

  // Méthode pour sélectionner l'heure avec le widget TimePicker
  Future<void> _selectBedTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _bedTime,
    );
    if (pickedTime != null && pickedTime != _bedTime) {
      // Convertir TimeOfDay en DateTime
      DateTime newBedTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, pickedTime.hour, pickedTime.minute);

      // Vérifier si l'utilisateur spécifie un nouveau jour
      if (isNewDay) {
        // Si c'est un nouveau jour, on autorise l'heure du coucher à être après l'heure du réveil
        setState(() {
          _bedTime = pickedTime;
        });
      } else {
        // Sinon, on vérifie si l'heure de réveil est après l'heure du coucher
        if (_wakeUpTime != null &&
            newBedTime.isAfter(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              _wakeUpTime.hour,
              _wakeUpTime.minute,
            ))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bedtime cannot be after Wake Up time'),
            ),
          );
        } else {
          // Sinon, on vérifie si l'heure de réveil est après l'heure du coucher
          if (_wakeUpTime != null &&
              newBedTime.isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _wakeUpTime.hour,
                _wakeUpTime.minute,
              ))) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bedtime cannot be after Wake Up time'),
              ),
            );
          } else {
            setState(() {
              _bedTime = pickedTime;
            });
          }
        }
      }
    }
  }

  Future<void> _selectWakeUpTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _wakeUpTime,
    );
    if (pickedTime != null && pickedTime != _wakeUpTime) {
      // Convertir TimeOfDay en DateTime
      DateTime newWakeUpTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute);

      if (isNewDay) {
        setState(() {
          _wakeUpTime = pickedTime;
        });
      } else {
        // Vérifier si l'heure du coucher est supérieure à l'heure de réveil
        if (_bedTime != null &&
            newWakeUpTime.isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _bedTime.hour,
                _bedTime.minute))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wake Up time cannot be before Bedtime'),
            ),
          );
        } else {
          setState(() {
            _wakeUpTime = pickedTime;
          });
        }
      }
    }
  }

// Méthode pour gérer le changement de statut du contrôle de saisie "Nouveau jour"
  void _handleNewDay(bool? value) {
    if (value != null) {
      setState(() {
        isNewDay = value;
      });
    }
  }
}
