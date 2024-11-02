import 'package:flutter/material.dart';
import 'package:epilepto_guard/models/drug.dart'; 
import 'package:epilepto_guard/widgets/DrugCard.dart'; 
import 'package:epilepto_guard/Screens/Drugs/add.dart';
import 'package:epilepto_guard/services/drugService.dart';

class ListDrug extends StatefulWidget {
  @override
  _ListDrugState createState() => _ListDrugState();
}

class _ListDrugState extends State<ListDrug> {
  final DrugService drugService = DrugService();
  List<Drug> drugs = [];

  @override
  void initState() {
    super.initState();
    fetchDrugs();
  }

  Future<void> fetchDrugs() async {
    try {
      List<Drug> fetchedDrugs = await drugService.getAllDrugs();
      setState(() {
        drugs = fetchedDrugs;
      });
    } catch (e) {
      print('Erreur de chargement des drugs : $e');
      // Gérer les erreurs de chargement des drugs
    }
  }

  Future<void> _refresh() async {
    // Mettez à jour la liste des drugs
    await fetchDrugs();
  }
@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de médicaments'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background/login.png"), // Assurez-vous que le chemin est correct
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: drugs.length,
                itemBuilder: (context, index) {
                  return DrugCard(drug: drugs[index], drugService: drugService,);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMedicineScreen()),
                        );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Add Drug',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A4FE9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
