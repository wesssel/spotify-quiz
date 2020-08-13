import 'package:flutter/material.dart';
import 'package:spotifyquiz/store/playlist.dart';
import 'package:spotifyquiz/store/quiz.dart';
import 'package:spotifyquiz/store/user.dart';

class Store extends ChangeNotifier {
  StoreUser user = StoreUser();
  StorePlaylist playlist = StorePlaylist();
  StoreQuiz quiz = StoreQuiz();
}
