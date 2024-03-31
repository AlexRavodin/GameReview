import 'package:cloud_firestore/cloud_firestore.dart';

class Game {

  String id;
  String name;
  String description;
  String genre;
  int minimumAge;

  Game(this.id, this.name, this.description, this.genre, this.minimumAge);

  factory Game.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Game(
      doc.id,
      data['name'] ?? '',
      data['description'] ?? '',
      data['genre'] ?? '',
      data['minimumAge'] ?? 0,
    );
  }

}