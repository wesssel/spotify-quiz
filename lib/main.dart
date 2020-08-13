import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyquiz/screens/login.dart';
import 'package:spotifyquiz/screens/quiz.dart';
import 'package:spotifyquiz/screens/select_device.dart';
import 'package:spotifyquiz/screens/select_playlist.dart';
import 'package:spotifyquiz/store/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Store>(
      create: (context) => Store(),
      child: MaterialApp(
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SelectPlaylistScreen.id: (context) => SelectPlaylistScreen(),
          SelectDeviceScreen.id: (context) => SelectDeviceScreen(),
          QuizScreen.id: (context) => QuizScreen(),
        },
      ),
    );
  }
}
