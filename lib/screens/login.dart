import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:provider/provider.dart';
import 'package:spotifyquiz/constants/app.dart';
import 'package:spotifyquiz/constants/spotify.dart';
import 'package:spotifyquiz/components/button.dart';
import 'package:spotifyquiz/screens/select_playlist.dart';
import 'package:spotifyquiz/store/index.dart';
import 'package:spotifyquiz/utils/spotify_rest.dart';

SpotifyRest spotifyRest = SpotifyRest();

class LoginScreen extends StatefulWidget {
  static String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void connectUser() async {
    try {
      final store = Provider.of<Store>(context, listen: false);
      final url =
          '$kSpotifyAccountUrl/authorize?client_id=$kSpotifyClientId&redirect_uri=$kAppName://callback&scope=${kSpotifyScopes.join('&')}&response_type=token&state=123';
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: kAppName,
      );

      final resUrl = Uri.parse(result).fragment;
      final String token = resUrl.split('&')[0].replaceAll('access_token=', '');

      store.user.setToken(token);

      await loadUser();

      Navigator.pushNamed(context, SelectPlaylistScreen.id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadUser() async {
    final store = Provider.of<Store>(context, listen: false);
    List<String> userData = await spotifyRest.getUser(store.user.token);

    store.user.setName(userData[0]);
    store.user.setImageUrl(userData[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/spotify.svg'),
              SizedBox(height: 32),
              Button(
                text: 'Connect to Spotify',
                onPressed: () {
                  connectUser();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
