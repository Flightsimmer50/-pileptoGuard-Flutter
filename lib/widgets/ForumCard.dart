import 'package:flutter/material.dart';
import 'package:epilepto_guard/models/Forum.dart';
import 'package:epilepto_guard/services/ForumService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:epilepto_guard/screens/Forum/ModifyForumDialog.dart';

class ForumCard extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  String? image; // Ajout de l'image
  final String? idUser;
  final Forum forum;

  ForumCard({
    required this.forum,
    this.firstName,
    this.lastName,
    this.image,
     this.idUser,
  });

  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  bool _liked = false;
  bool _commentExpanded = false;
  late String loadedFirstName;
  late String loadedLastName;
  late String loadedImage;
  late String loadedidUser;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = FlutterSecureStorage();

    loadedFirstName = await storage.read(key: "firstName") ?? '';
    loadedLastName = await storage.read(key: "lastName") ?? '';
    loadedImage = await storage.read(key: "image") ?? '';
    loadedidUser = await storage.read(key: "idUser") ?? '';

    setState(() {}); // Mettre à jour l'état après le chargement des données
  }

  void deleteFeedback(String description) async {
    try {
      await ForumService().deleteFeedback(description);
    } catch (e) {
      // Ignorer les erreurs de suppression
    }
  }

  void toggleLike() {
    setState(() {
      _liked = !_liked;
    });
  }

  void toggleCommentExpanded() {
    setState(() {
      _commentExpanded = !_commentExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Choose the right option'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                        // Action à effectuer lors de la sélection de l'option "Modify"
                         Navigator.of(context).pop(); // Ferme le dialogue actuel
                         Navigator.push( // Navigue vers la page de modification
                         context,
                         MaterialPageRoute(
                         builder: (context) => ModifyForumDialog(
                         currentDescription: widget.forum.description ?? '', // Passez la description actuelle à la page de modification
                        ),
                        ),
                        );
                        },
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Modify', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      // Action à effectuer lors de la sélection de l'option "Delete"
                      Navigator.of(context).pop();
                      deleteFeedback(widget.forum.description ?? '');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Delete', style: TextStyle(color: Colors.red)),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.all(8.0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30, // Définir la taille du cercle
                          backgroundImage: loadedImage.isNotEmpty
                              ? NetworkImage(loadedImage)
                              : null, // Utiliser l'image du réseau si elle est disponible
                          child: loadedImage.isEmpty
                              ? Text(
                                  '${loadedFirstName[0]}${loadedLastName[0]}')
                              : null, // Utiliser les initiales si l'image n'est pas disponible
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$loadedFirstName $loadedLastName',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${widget.forum.description}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: toggleLike,
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: _liked ? Colors.red : Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(_liked ? 'You Liked this Feedback' : 'Like'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // Aligner à droite
                  children: [
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: toggleCommentExpanded,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.comment,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8),
                              Text('Comment'),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    _commentExpanded
                        ? Column(
                            children: [
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Write your comment...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // Add logic to handle sending comment
                                },
                                child: Text('Send'),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
