import 'package:flutter/cupertino.dart';

class StoreQuiz extends ChangeNotifier {
  int _selectedPlaylistIndex;

  get selectedPlaylistIndex {
    return _selectedPlaylistIndex;
  }

  setSelectedPlaylistIndex(int index) {
    _selectedPlaylistIndex = index;
  }
}
