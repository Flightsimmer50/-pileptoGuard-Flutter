import 'package:flutter/material.dart';
import 'package:epilepto_guard/models/drug.dart'; 
import 'package:epilepto_guard/Screens/Drugs/modify.dart';
import 'package:epilepto_guard/services/drugService.dart';

class DrugDetailScreen extends StatelessWidget {
  final Drug drug; // Médicament à afficher
  final DrugService drugService;

  const DrugDetailScreen({Key? key, required this.drug, required this.drugService}) : super(key: key);

  Future<void> deleteDrug(BuildContext context) async {
    // Affichez une boîte de dialogue de confirmation avant la suppression
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention !"),
          content: Text(
              "This operation is definitive ! Are you sure to delete this drug ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Annuler la suppression
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmer la suppression
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    // Supprimez la condition confirmDelete et procédez à la suppression directement
    try {
      await drugService.deleteDrug(drug.name);
    } catch (e) {
      // Ignorer les erreurs de suppression
    }

    // Après la suppression réussie ou échouée, vous pouvez naviguer vers une autre page ou effectuer d'autres actions.
    Navigator.pop(context, true); // Revenir à l'écran précédent après la suppression
  }

  Widget buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.greenAccent),
        SizedBox(width: 8),
        Text('$label: $value', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drug Detail'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background/login.png'), // Modifier avec votre propre image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Affichage de l'image du médicament
                SizedBox(
                  height: 200, // Ajustez la hauteur de l'image selon vos besoins
                  child: Image.asset(
                    'images/background/parkizol.png', // Chemin vers votre image statique
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 20),
                // Affichage des détails du médicament
                Text(
                  'Name: ${drug.name}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Description: ${drug.description ?? "N/A"}'),
                SizedBox(height: 10),
                Text('Start Taking Date: ${drug.startTakingDate.toString()}'),
                SizedBox(height: 10),
                Text('End Taking Date: ${drug.endTakingDate.toString()}'),
                SizedBox(height: 10),
                Text('Day of Week: ${drug.dayOfWeek ?? "N/A"}'),
                SizedBox(height: 10),
                Text('Number of Time A Day: ${drug.numberOfTimeADay}'),
                SizedBox(height: 10),
                Text('Quantity Per Take: ${drug.quantityPerTake ?? "N/A"}'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateMedicineScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Modify'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          deleteDrug(context); // Appeler la méthode de suppression
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
