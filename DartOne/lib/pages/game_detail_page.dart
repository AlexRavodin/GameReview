import 'package:flutter/material.dart';

import '../model/game.dart';
import '../provider/data_provider.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;
  final String userId;

  GameDetailPage({super.key, required this.game, required this.userId});

  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  bool _isFavorite = false;
  late final _gameProvider;

  @override
  void initState() {
    super.initState();
    _gameProvider = DataProvider();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    bool isFavorite = await _gameProvider.isFavorite(widget.userId, widget.game.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  void _toggleFavorite() async {
    await _gameProvider.toggleFavoriteStatus(widget.userId, widget.game.id);
    _checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Description: ${widget.game.description}"),
            Text("Genres: ${widget.game.genre}"),
            Text("Minimum Age: ${widget.game.minimumAge}"),
            // Добавьте виджеты для отображения дополнительных картинок и т.д.
          ],
        ),
      ),
    );
  }
}