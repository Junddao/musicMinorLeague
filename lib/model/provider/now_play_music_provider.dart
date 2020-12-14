import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:flutter/material.dart';

class NowPlayMusicProvider with ChangeNotifier {
  MusicInfoData _musicInfoData;
  List<MusicInfoData> _musicList;
  List<MusicInfoData> _selectedMusicList;
  List<bool> _selectList;
  String _nowMusicId;
  bool _isPlay = false;

  List<MusicInfoData> get selectedMusicList => _selectedMusicList;
  set selectedMusicList(List<MusicInfoData> selectedMusicList) {
    // _selectedMusicList
    _selectedMusicList = List.from(selectedMusicList);
    notifyListeners();
  }

  List<MusicInfoData> get musicList => _musicList;
  set musicList(List<MusicInfoData> musicList) {
    // _selectedMusicList
    _musicList = List.from(musicList);
    notifyListeners();
  }

  List<bool> get selectList => _selectList;
  set selectList(List<bool> selectList) {
    // _selectedMusicList
    _selectList = List.from(selectList);
    notifyListeners();
  }

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
