import 'dart:convert';

import 'package:http/http.dart';
import 'package:spotifyquiz/constants/spotify.dart';
import 'package:spotifyquiz/models/device.dart';
import 'package:spotifyquiz/models/playlist.dart';
import 'package:spotifyquiz/models/track.dart';

class SpotifyRest {
  Future<dynamic> _get(String url, String token) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    Response response = await get(url, headers: headers);
    dynamic data = jsonDecode(response.body);

    return data;
  }

  Future<void> _put(String url, String token, String body) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return put(url, headers: headers, body: body);
  }

  Future<List<String>> getUser(String token) async {
    dynamic data = await _get('$kSpotifyApiUrl/v1/me', token);

    return [
      data['display_name'],
      data['images'][0] != null ? data['images'][0]['url'] : '',
    ];
  }

  Future<Playlist> getPlaylist(String token, String playlistId) async {
    dynamic data =
        await _get('$kSpotifyApiUrl/v1/playlists/$playlistId', token);

    List<Track> tracks = data['tracks'] != null
        ? data['tracks']['items']
            .map<Track>(
                (t) => Track(name: t['track']['name'], id: t['track']['id']))
            .toList()
        : [];

    Playlist playlist = Playlist(
      name: data['name'],
      id: data['id'],
      imageUrl: data['images'] != null && data['images'][0] != null
          ? data['images'][0]['url']
          : '',
      tracks: tracks,
    );

    return playlist;
  }

  Future<List<Device>> getDevices(String token) async {
    dynamic data = await _get('$kSpotifyApiUrl/v1/me/player/devices', token);

    List<Device> devices = data['devices'] != null
        ? data['devices']
            .map<Device>((d) => Device(
                  id: d['id'],
                  name: d['name'],
                  isActive: d['is_active'],
                ))
            .toList()
        : [];

    return devices;
  }

  playTrack(String token, String trackId) async {
    Map body = {
      'uris': ['spotify:track:$trackId']
    };

    return _put('$kSpotifyApiUrl/v1/me/player/play', token, json.encode(body));
  }

  Future<List<String>> getStatus(String token) async {
    dynamic data = await _get('$kSpotifyApiUrl/v1/me/player', token);

    return [
      data['device']['id'], // deviceId
      data['item']['id'], // trackId
    ];
  }
}
