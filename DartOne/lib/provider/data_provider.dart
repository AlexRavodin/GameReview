import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/game.dart';
import '../model/user.dart';

class DataProvider {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Game>> fetchGames() {
    StreamController<List<Game>> controller = StreamController<List<Game>>();

    _firestore.collection('games').snapshots().listen((snapshot) {
      List<Game> games = snapshot.docs.map((doc) {
        return Game.fromFirestore(doc);
      }).toList();

      controller.add(games);
    });

    return controller.stream;
  }

  Future<void> addUserToCollection(User user) async {
    try {
      await _firestore.collection('users').add({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'favoriteGenre': user.favoriteGenre,
        'favoriteGame': user.favoriteGame,
        'age': user.age,
      });

      print('Пользователь успешно добавлен в коллекцию.');
    } catch (e) {
      print('Ошибка при добавлении пользователя в коллекцию: $e');
    }
  }

  Stream<List<Game>> fetchFavoriteGamesForUser(String userId) {
    StreamController<List<Game>> controller = StreamController<List<Game>>();

    _firestore.collection('favorite_items').where('userId', isEqualTo: userId)
        .snapshots().listen((snapshot) async {
      List<Game> games = [];


      for (var doc in snapshot.docs) {
        print(doc);
        String gameId = doc.data()['gameId'];
        var gameSnapshot = await _firestore.collection('games').doc(gameId).get();

        if (gameSnapshot.exists) {
          games.add(Game.fromFirestore(gameSnapshot));
        }
      }

      controller.add(games);
    });

    return controller.stream;
  }

  Future<void> toggleFavoriteStatus(String userId, String gameId) async {
    final collection = _firestore.collection('favorite_items');
    final snapshot = await collection
        .where('UserId', isEqualTo: userId)
        .where('GameId', isEqualTo: gameId)
        .get();

    if (snapshot.docs.isEmpty) {
      await collection.add({
        'UserId': userId,
        'GameId': gameId,
      });
    } else {
      await collection.doc(snapshot.docs.first.id).delete();
    }
  }

  Future<bool> isFavorite(String userId, String gameId) async {
    final snapshot = await _firestore
        .collection('favorite_items')
        .where('UserId', isEqualTo: userId)
        .where('GameId', isEqualTo: gameId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

}