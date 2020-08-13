import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyquiz/constants/spotify.dart';
import 'package:spotifyquiz/models/playlist.dart';
import 'package:spotifyquiz/screens/select_device.dart';
import 'package:spotifyquiz/store/index.dart';
import 'package:spotifyquiz/store/playlist.dart';
import 'package:spotifyquiz/store/quiz.dart';
import 'package:spotifyquiz/store/user.dart';
import 'package:spotifyquiz/utils/spotify_rest.dart';

SpotifyRest spotifyRest = SpotifyRest();

class SelectPlaylistScreen extends StatefulWidget {
  static String id = 'select_playlist';

  @override
  _SelectPlaylistScreenState createState() => _SelectPlaylistScreenState();
}

class _SelectPlaylistScreenState extends State<SelectPlaylistScreen> {
  bool isLoaded = false;

  StoreUser get userStore {
    return Provider.of<Store>(context).user;
  }

  StorePlaylist get playlistStore {
    return Provider.of<Store>(context).playlist;
  }

  StoreQuiz get quizStore {
    return Provider.of<Store>(context, listen: false).quiz;
  }

  loadPlaylists() async {
    Store store = Provider.of<Store>(context, listen: false);

    for (String id in kSpotifyPlaylistIds) {
      final playlist = await spotifyRest.getPlaylist(store.user.token, id);

      if (playlist.id != null) {
        store.playlist.addToList(playlist);
      }
    }

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  Widget createPlaylistTile(Playlist playlist, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          quizStore.setSelectedPlaylistIndex(index);
          Navigator.pushNamed(context, SelectDeviceScreen.id);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [Image(image: NetworkImage(playlist.imageUrl))],
          ),
        ),
      ),
    );
  }

  List<Widget> get playlistRows {
    List<Row> rows = [
      Row(children: []),
    ];

    for (int index = 0; index < (playlistStore.list.length - 1); index++) {
      Playlist playlist = playlistStore.list[index];
      Row lastRow = rows.last;

      if (lastRow == null || lastRow.children.length == 2) {
        rows.add(Row(children: [createPlaylistTile(playlist, index)]));
      } else {
        lastRow.children.add(createPlaylistTile(playlist, index));
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 32, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userStore.imageUrl),
                    radius: 32.0,
                  ),
                  SizedBox(width: 16),
                  Text(userStore.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(children: playlistRows),
          ],
        ),
      ),
    );
  }
}
