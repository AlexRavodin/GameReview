import 'package:flutter/material.dart';
import 'package:game_review/pages/user_detail_page.dart';

import '../pages/game_detail_page.dart';

import 'package:game_review/provider/data_provider.dart';
import '../model/game.dart';


class GamesListPage extends StatefulWidget {
  final String userId;

  const GamesListPage({super.key, required this.userId});

  @override
  _GamesListPageState createState() => _GamesListPageState();
}

class _GamesListPageState  extends State<GamesListPage> {
  final _gameProvider = DataProvider();
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games List'),
        actions: <Widget>[
          Switch(
            value: _showFavoritesOnly,
            onChanged: (bool value) {
              setState(() {
                _showFavoritesOnly = value;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserPage(widget.userId)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Game>>(
        stream: _showFavoritesOnly
            ? _gameProvider.fetchFavoriteGamesForUser(widget.userId)
            : _gameProvider.fetchGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Game game = snapshot.data![index];
                return ListTile(
                  title: Text(game.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailPage(userId: widget.userId, game: game),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }


}
