import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../model/game.dart';
import '../provider/data_provider.dart';

class GameDetailPage extends StatefulWidget {
  final Game game;
  final String userId;

  const GameDetailPage({super.key, required this.game, required this.userId});

  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  bool _isFavorite = false;
  late final DataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = DataProvider();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    bool isFavorite = await _dataProvider.isFavorite(widget.userId, widget.game.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  void _toggleFavorite() async {
    await _dataProvider.toggleFavoriteStatus(widget.userId, widget.game.id);
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
            FutureBuilder<List<String>>(
              future: _dataProvider.fetchImageUrls(widget.game.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No images available");
                }

                List<String> images = snapshot.data!;
                return CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: images.map((String url) {
                    return Builder(
                      builder: (BuildContext context) {
                        //print(url);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(url, fit: BoxFit.cover),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

    );
  }
}