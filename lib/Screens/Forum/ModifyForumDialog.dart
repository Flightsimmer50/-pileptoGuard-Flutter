import 'package:flutter/material.dart';
import 'package:epilepto_guard/models/Forum.dart';
import 'package:epilepto_guard/services/ForumService.dart';

class ModifyForumDialog extends StatefulWidget {
  final String currentDescription;

  ModifyForumDialog({required this.currentDescription});

  @override
  _ModifyForumDialogState createState() => _ModifyForumDialogState();
}

class _ModifyForumDialogState extends State<ModifyForumDialog> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modify Feedback'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write your feedback...',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String newDescription = _descriptionController.text;
            if (newDescription.isNotEmpty) {
              try {
                // Appel de la méthode updateFeedback de ForumService
               // await ForumService().updateFeedback(widget.currentDescription, Forum(description: newDescription));
                Navigator.pop(context, newDescription); // Ferme la boîte de dialogue et renvoie la nouvelle description
              } catch (e) {
                // Gérer les erreurs
                print('Error updating feedback: $e');
              }
            } else {
              // Afficher un message d'erreur ou gérer le cas de description vide
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
