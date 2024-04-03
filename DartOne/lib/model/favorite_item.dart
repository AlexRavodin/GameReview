import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  String id;
  String userId;
  String gameId;

  FavoriteItem(this.id, this.userId, this.gameId);

  factory FavoriteItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return FavoriteItem(
      doc.id,
      data['userId'] ?? '',
      data['gameId'] ?? '',
    );
  }
}