import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:flutter/material.dart';

class NowPlayMusicProvider with ChangeNotifier {
  MusicInfoData _musicInfoData;

  String _nowMusicId;
  bool _isPlay = false;

  MusicInfoData get musicInfoData => _musicInfoData;
  set musicInfoData(MusicInfoData musicInfoData) {
    _musicInfoData = musicInfoData;
    notifyListeners();
  }

  String get nowMusicId => _nowMusicId;
  set nowMusicId(String nowMusicId) {
    _nowMusicId = nowMusicId;
    notifyListeners();
  }

  bool get isPlay => _isPlay;
  set isPlay(bool isPlay) {
    _isPlay = isPlay;
    notifyListeners();
  }
}
