import 'package:flutter/material.dart';

class UrlInfo with ChangeNotifier {
  String _url = 'empty';
  String get url => _url;
  set url(String url) {
    _url = url;
    notifyListeners();
  }
}
