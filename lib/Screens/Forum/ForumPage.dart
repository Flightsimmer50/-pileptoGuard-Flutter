import 'package:flutter/material.dart';
import 'package:epilepto_guard/models/Forum.dart';
import 'package:epilepto_guard/widgets/ForumCard.dart';
import 'package:epilepto_guard/services/ForumService.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final ForumService _forumService = ForumService();
  TextEditingController _textEditingController = TextEditingController();
  Forum _newForum = Forum(description: '');

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Forum>>(
          future: _forumService.getAllFeedbacks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final forums = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: forums.length,
                      itemBuilder: (context, index) {
                        final forum = forums[index];
                        // Supposons que chaque forum a un utilisateur associé
                        return Column(
                          children: [
                            ForumCard(
                              forum: forum,
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Write a Feedback...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _newForum = Forum(description: _textEditingController.text);
                            });
                            _forumService.addFeedback(_newForum);
                            _textEditingController.clear(); // Effacer le texte après l'envoi
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
