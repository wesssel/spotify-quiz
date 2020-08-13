import 'package:flutter/cupertino.dart';
import 'package:spotifyquiz/models/device.dart';

class StoreUser extends ChangeNotifier {
  String _token = '';
  String _name = '';
  String _imageUrl = '';
  List<Device> _devices = [];

  String get token {
    return _token;
  }

  setToken(String token) {
    _token = token;
    notifyListeners();
  }

  String get name {
    return _name;
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  String get imageUrl {
    return _imageUrl;
  }

  setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  List<Device> get devices {
    return _devices;
  }

  setDevices(List<Device> devices) {
    _devices = devices;
    notifyListeners();
  }
}
