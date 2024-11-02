import 'package:flutter/foundation.dart';

class Drug {
   String name;
   String? description;
   String? image;
   DateTime startTakingDate;
   DateTime endTakingDate;
   String? dayOfWeek;
   String numberOfTimeADay;
   int? quantityPerTake;
   //String? user;

  Drug({
     
    required this.name,
     this.description,
     this.image,
     required this.startTakingDate,
     required this.endTakingDate,
     this.dayOfWeek,
     required this.numberOfTimeADay,
     this.quantityPerTake,
     //this.user,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      startTakingDate: DateTime.parse(json['startTakingDate'] as String),
      endTakingDate: DateTime.parse(json['endTakingDate'] as String),
      dayOfWeek: json['dayOfWeek'] as String,
      numberOfTimeADay: json['numberOfTimeADay'] as String,
      quantityPerTake: json['quantityPerTake'] as int,
      //user: json['user'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'image': image,
        'startTakingDate': startTakingDate.toIso8601String(),
        'endTakingDate': endTakingDate.toIso8601String(),
        'dayOfWeek': dayOfWeek,
        'numberOfTimeADay': numberOfTimeADay,
        'quantityPerTake': quantityPerTake,
        //'user': user,
      };
}
