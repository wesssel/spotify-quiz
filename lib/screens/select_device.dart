import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotifyquiz/components/button.dart';
import 'package:spotifyquiz/models/device.dart';
import 'package:spotifyquiz/models/playlist.dart';
import 'package:spotifyquiz/models/track.dart';
import 'package:spotifyquiz/screens/quiz.dart';
import 'package:spotifyquiz/store/index.dart';
import 'package:spotifyquiz/store/playlist.dart';
import 'package:spotifyquiz/store/quiz.dart';
import 'package:spotifyquiz/store/user.dart';
import 'package:spotifyquiz/utils/spotify_rest.dart';

SpotifyRest spotifyRest = SpotifyRest();

class SelectDeviceScreen extends StatefulWidget {
  static String id = 'select_device';

  @override
  _SelectDeviceScreenState createState() => _SelectDeviceScreenState();
}

class _SelectDeviceScreenState extends State<SelectDeviceScreen> {
  Device selectedDevice;
  bool isTestSuccess = false;

  Playlist get selectedPlaylist {
    return playlistStore.list[quizStore.selectedPlaylistIndex];
  }

  Track get firstTrack {
    return selectedPlaylist.tracks.first;
  }

  StoreUser get userStore {
    return Provider.of<Store>(context, listen: false).user;
  }

  StoreQuiz get quizStore {
    return Provider.of<Store>(context, listen: false).quiz;
  }

  StorePlaylist get playlistStore {
    return Provider.of<Store>(context, listen: false).playlist;
  }

  loadDevices() async {
    List<Device> devices = await spotifyRest.getDevices(userStore.token);

    setState(() {
      userStore.setDevices(devices);
    });
  }

  testPlay() async {
    await spotifyRest.playTrack(userStore.token, firstTrack.id);
    List<String> status = await spotifyRest.getStatus(userStore.token);

    if (status[0] == selectedDevice.id && status[1] == firstTrack.id) {
      setState(() {
        isTestSuccess = true;
      });
    }
  }

  init() async {
    await loadDevices();

    selectedDevice = userStore.devices[0];
  }

  @override
  void initState() {
    super.initState();
    init();
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
              Container(
                child: isTestSuccess == true
                    ? Button(
                        text: 'Start Quiz',
                        onPressed: () {
                          Navigator.pushNamed(context, QuizScreen.id);
                        },
                      )
                    : null,
              ),
              Container(
                child: firstTrack != null && isTestSuccess == false
                    ? Button(
                        text: 'Test - ${firstTrack.name}',
                        onPressed: () {
                          testPlay();
                        },
                      )
                    : null,
              ),
              SizedBox(height: 16),
              Button(
                text: 'Reload Devices',
                onPressed: () {
                  loadDevices();
                },
              ),
              SizedBox(height: 40),
              DropdownButton<String>(
                value: selectedDevice != null ? selectedDevice.id : '',
                items: Provider.of<Store>(context, listen: true)
                    .user
                    .devices
                    .map((d) => DropdownMenuItem(
                          child: Text(d.name),
                          value: d.id,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    print(value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
