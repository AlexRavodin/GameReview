import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  String id;
  String email;
  String name;
  String favoriteGenre;
  String favoriteGame;
  int age;

  User(this.id, this.email, this.name, this.favoriteGenre, this.favoriteGame, this.age);

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return User(
      doc.id,
      data['email'] ?? '',
      data['name'] ?? '',
      data['favoriteGenre'] ?? '',
      data['favoriteGame'] ?? '',
      data['age'] ?? 0,
    );
  }
}