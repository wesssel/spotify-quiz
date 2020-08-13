import 'package:flutter/cupertino.dart';
import 'package:spotifyquiz/models/playlist.dart';

class StorePlaylist extends ChangeNotifier {
  List<Playlist> _list = [];

  List<Playlist> get list {
    return _list;
  }

  setList(List<Playlist> list) {
    _list = list;
    notifyListeners();
  }

  addToList(Playlist playlist) {
    _list.add(playlist);
    notifyListeners();
  }
}
