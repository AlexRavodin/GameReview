import 'package:cloud_firestore/cloud_firestore.dart';

class GameImage {
  String id;
  String gameId;
  String url;

  GameImage(this.id, this.gameId, this.url);

  factory GameImage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return GameImage(
      doc.id,
      data['gameId'] ?? '',
      data['url'] ?? '',
    );
  }
}