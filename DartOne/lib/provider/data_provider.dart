import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_review/provider/image_provider.dart';

import '../model/game.dart';
import '../model/user.dart';

class DataProvider {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const gameCollection = "games";
  static const favoriteItemCollection = "favorite_items";
  static const userCollection = "users";
  static const imageCollection = "images";

  Future<void> updateUser(User user) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = snapshot.docs.first;
      await document.reference.update({
        'name': user.name,
        'email': user.email,
        'favoriteGenre': user.favoriteGenre,
        'favoriteGame': user.favoriteGame,
        'age': user.age,
      });
    }
    else {
      throw Exception();
    }
  }

  Future<void> addUser(User user) async {
    await _firestore.collection('users').add({
      'id' : user.id,
      'name': user.name,
      'email': user.email,
      'favoriteGenre': user.favoriteGenre,
      'favoriteGame': user.favoriteGame,
      'age': user.age,
    });
  }

  Future<User?> loadUser(String userId) async {
    final user = await fetchUserData(userId);
    if (user != null) {
      return user;
    }

    return null;
  }

  Future<void> deleteUser(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot document = snapshot.docs.first;
      await document.reference.delete();
    }
    else {
      throw Exception();
    }
  }

  Future<User?> fetchUserData(String uid) async {
    final userDoc = await _firestore
        .collection('users')
        .where('id', isEqualTo: uid)
        .limit(1)
        .get();

    if (userDoc.docs.isNotEmpty) {
      return User.fromFirestore(userDoc.docs.first);;
    } else {
      return null;
    }
  }

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

  Stream<List<Game>> fetchFavoriteGamesForUser(String userId) {
    StreamController<List<Game>> controller = StreamController<List<Game>>();

    _firestore.collection('favorite_items').where('userId', isEqualTo: userId)
        .snapshots().listen((snapshot) async {
      List<Game> games = [];


      for (var doc in snapshot.docs) {
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
        .where('userId', isEqualTo: userId)
        .where('gameId', isEqualTo: gameId)
        .get();

    if (snapshot.docs.isEmpty) {
      await collection.add({
        'userId': userId,
        'gameId': gameId,
      });
    } else {
      await collection.doc(snapshot.docs.first.id).delete();
    }
  }

  Future<bool> isFavorite(String userId, String gameId) async {
    final snapshot = await _firestore
        .collection('favorite_items')
        .where('userId', isEqualTo: userId)
        .where('gameId', isEqualTo: gameId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<String>> fetchImageUrls(String gameId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('game_images')
        .where('gameId', isEqualTo: gameId)
        .get();

     var futures = snapshot.docs.map((doc) async {
      ImageProvider imageProvider = ImageProvider();

      return await imageProvider.normalizeFirebaseUrl(doc['url']);
    });

    List<String> imageUrls = await Future.wait(futures);

    return imageUrls;
  }

}