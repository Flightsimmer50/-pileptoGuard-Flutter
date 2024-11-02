import 'package:epilepto_guard/Models/postCriseForm.dart';
import 'package:epilepto_guard/Services/postFormService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SubmittedForm extends StatelessWidget {
  final String id;
  final PostFormService postFormService =
      PostFormService(); // Instance de votre service

  SubmittedForm({required this.id});

  void _dummyFunction(bool? value) {
    // Cette fonction ne fait rien
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postFormService.getFormData(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          var formData = snapshot.data as PostCriseFormData?;
          if (formData != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Submitted Form'),
              ),
              body: SingleChildScrollView(
                // Wrap the body with SingleChildScrollView
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Post Seizure Form : ',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.0),
                      _buildQuestionWithResponse(
                        'How long did the seizure last?',
                        TextFormField(
                          readOnly: true,
                          initialValue:
                              '${formData.selectedHours} hours ${formData.selectedMinutes} minutes',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'When did you first feel the initial signs of the seizure?',
                        TextFormField(
                          readOnly: true,
                          initialValue: '${formData.response1} ',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Did you experience an aura before the seizure?',
                        Column(
                          children: [
                            _buildCheckboxQuestionForNullableBool(
                              'Visual Aura',
                              formData?.visualAuraChecked ?? false,
                              _dummyFunction, // Passer null pour la fonction onChanged
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Sensory Aura',
                              formData.sensoryAuraChecked ?? false,
                              //(value) {},
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Auditory Aura',
                              formData.auditoryAuraChecked ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Gustatory or Olfactory Aura',
                              formData.gustatoryOrOlfactoryAuraChecked ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Headaches',
                              formData.headachesChecked ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Excessive Fatigue',
                              formData.excessiveFatigueChecked ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Abnormal Mood',
                              formData.abnormalMoodChecked ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Sleep Disturbances',
                              formData.sleepDisturbancesChecked ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Concentration Difficulties',
                              formData.concentrationDifficultiesChecked ??
                                  false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestionForNullableBool(
                              'Increased Sensitivity',
                              formData.increasedSensitivityChecked ?? false,
                              _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Are identifiable triggering factors present ?',
                        Column(
                          children: [
                            _buildCheckboxQuestion(
                              'Emotional or psychological stress, such as anxiety or fear, or physical stress',
                              formData.triggerFactorsSelection?[0] ?? false,
                              //(value) {},
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Lack of sleep or sleep disruption',
                              formData.triggerFactorsSelection?[1] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Excessive alcohol or drug consumption',
                              formData.triggerFactorsSelection?[2] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Bright flashes or stroboscopic lights',
                              formData.triggerFactorsSelection?[3] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Omission or interruption of anticonvulsant medication',
                              formData.triggerFactorsSelection?[4] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Hormones',
                              formData.triggerFactorsSelection?[5] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Extreme fatigue or lack of rest',
                              formData.triggerFactorsSelection?[6] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Consumption of certain foods or drinks (caffeine, aspartame, certain food additives)',
                              formData.triggerFactorsSelection?[7] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Changes in body temperature',
                              formData.triggerFactorsSelection?[8] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Certain physical activities or specific sports',
                              formData.triggerFactorsSelection?[9] ?? false,
                              _dummyFunction,
                            ),
                            _buildCheckboxQuestion(
                              'Illness',
                              formData.triggerFactorsSelection?[10] ?? false,
                              _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Were you injured during the seizure?',
                        TextFormField(
                          readOnly: true,
                          initialValue: '${formData.injured} ',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Did you notice any changes in your emotional state after the seizure?',
                        RatingBar.builder(
                          initialRating: formData.emotionalStateRating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 40.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: const Color(0xFF8A4FE9),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'How would you describe the post-seizure recovery in terms of fatigue and the time required to regain normal capabilities?',
                        RatingBar.builder(
                          initialRating: formData.recoveryRating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 40.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: const Color(0xFF8A4FE9),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Are you regular in your medication intake?',
                        Column(
                          children: [
                            RadioListTile<bool>(
                              title: Text('Yes'),
                              value: true,
                              groupValue: formData.medicationIntake ?? false,
                              onChanged:
                                  _dummyFunction, // Rendre non interactif
                            ),
                            RadioListTile<bool>(
                              title: Text('No'),
                              value: false,
                              groupValue: formData.medicationIntake ?? false,
                              onChanged:
                                  _dummyFunction, // null, // Rendre non interactif
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Were you conscious during the seizure, or did you lose consciousness?',
                        Column(
                          children: [
                            RadioListTile<bool>(
                              title: Text('Yes'),
                              value: true,
                              groupValue: formData.conscious ?? false,
                              // onChanged: null,
                              onChanged: _dummyFunction,
                            ),
                            RadioListTile<bool>(
                              title: Text('No'),
                              value: false,
                              groupValue: formData.conscious ?? false,
                              onChanged: _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Did the seizure involve repeated episodes without fully regaining consciousness in between?',
                        Column(
                          children: [
                            RadioListTile<bool>(
                              title: Text('Yes'),
                              value: true,
                              groupValue: formData.episodes ?? false,
                              onChanged: _dummyFunction,
                            ),
                            RadioListTile<bool>(
                              title: Text('No'),
                              value: false,
                              groupValue: formData.episodes ?? false,
                              onChanged: _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Did you experience any memory disturbances after the seizure?',
                        Column(
                          children: [
                            RadioListTile<bool>(
                              title: Text('Yes'),
                              value: true,
                              groupValue: formData.memoryDisturbances ?? false,
                              onChanged: _dummyFunction,
                            ),
                            RadioListTile<bool>(
                              title: Text('No'),
                              value: false,
                              groupValue: formData.memoryDisturbances ?? false,
                              onChanged: _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'How would you assess your level of stress or anxiety before and after the seizure?',
                        RatingBar.builder(
                          initialRating: formData.stressAnxietyRating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 40.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: const Color(0xFF8A4FE9),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Did you experience any specific symptoms after the seizure, such as headaches, nausea, or dizziness?',
                        TextFormField(
                          readOnly: true,
                          initialValue: '${formData.response2} ',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Did you require medical assistance or emergency intervention?',
                        Column(
                          children: [
                            RadioListTile<bool>(
                              title: Text('Yes'),
                              value: true,
                              groupValue: formData.assistance ?? false,
                              onChanged: _dummyFunction,
                            ),
                            RadioListTile<bool>(
                              title: Text('No'),
                              value: false,
                              groupValue: formData.assistance ?? false,
                              onChanged: _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'How do you assess the medical care or assistance you received during the seizure?',
                        RatingBar.builder(
                          initialRating: formData.medicalCareRating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 40.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: const Color(0xFF8A4FE9),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Do you want additional advice on managing your epilepsy?',
                        Column(
                          children: [
                            RadioListTile<bool>(
                              title: Text('Yes'),
                              value: true,
                              groupValue: formData.advice ?? false,
                              onChanged: _dummyFunction,
                            ),
                            RadioListTile<bool>(
                              title: Text('No'),
                              value: false,
                              groupValue: formData.advice ?? false,
                              onChanged: _dummyFunction,
                            ),
                          ],
                        ),
                      ),
                      _buildQuestionWithResponse(
                        'Do you have anything to add?',
                        TextFormField(
                          readOnly: true,
                          initialValue: '${formData.response3} ',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        }
      },
    );
  }

  // Méthode pour construire un cadre question-réponse
  Widget _buildQuestionWithResponse(String question, Widget responseWidget) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          responseWidget,
        ],
      ),
    );
  }

  // Méthode pour construire une question avec cases à cocher bool
  Widget _buildCheckboxQuestion(
      String question, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF8A4FE9),
    );
  }

// Fonction pour construire une question avec cases à cocher pour bool?
  Widget _buildCheckboxQuestionForNullableBool(
      String question, bool? value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      value: value ?? false, // Gère le cas où value est null
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF8A4FE9),
    );
  }
}
