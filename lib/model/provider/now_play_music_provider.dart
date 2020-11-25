import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:flutter/material.dart';

class NowPlayMusicProvider with ChangeNotifier {
  MusicInfoData _musicInfoData;
  int _oldMusicIndex = -1;
  int _nowMusicIndex = -1;
  bool _isPlay = false;

  MusicInfoData get musicInfoData => _musicInfoData;
  set musicInfoData(MusicInfoData musicInfoData) {
    _musicInfoData = musicInfoData;
    notifyListeners();
  }

  int get oldMusicIndex => _oldMusicIndex;
  set oldMusicIndex(int oldMusicIndex) {
    _oldMusicIndex = oldMusicIndex;
    notifyListeners();
  }

  int get nowMusicIndex => _nowMusicIndex;
  set nowMusicIndex(int nowMusicIndex) {
    _nowMusicIndex = nowMusicIndex;
    notifyListeners();
  }

  bool get isPlay => _isPlay;
  set isPlay(bool isPlay) {
    _isPlay = isPlay;
    notifyListeners();
  }
}
