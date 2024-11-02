import 'dart:convert'; // Importez cette bibliothèque pour utiliser jsonDecode.

class Forum {
  final String? description;

  Forum({
    this.description,
  });

  // Méthode de désérialisation JSON pour créer une instance de Forum à partir d'un Map JSON.
  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      description: json['description'] as String?,
    );
  }

  // Méthode de sérialisation JSON pour convertir une instance de Forum en un Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}
