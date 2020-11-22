import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:flutter/material.dart';

class NowPlayMusicProvider with ChangeNotifier {
  MusicInfoData _musicInfoData;

  MusicInfoData get musicInfoData => _musicInfoData;
  set musicInfoData(MusicInfoData musicInfoData) {
    _musicInfoData = musicInfoData;
    notifyListeners();
  }
}
