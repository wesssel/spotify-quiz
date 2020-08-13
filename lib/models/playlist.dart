import 'package:spotifyquiz/models/track.dart';

class Playlist {
  String id;
  String name;
  String imageUrl;
  List<Track> tracks;

  Playlist({this.id, this.name, this.imageUrl, this.tracks});
}
