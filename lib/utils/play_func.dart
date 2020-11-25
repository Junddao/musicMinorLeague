import 'package:assets_audio_player/assets_audio_player.dart';

class PlayMusic {
  static AssetsAudioPlayer _assetsAudioPlayer = new AssetsAudioPlayer();
  static clearPlayList() {
    _assetsAudioPlayer.stop();

    _assetsAudioPlayer = new AssetsAudioPlayer();
  }

  static stopFunc() {
    _assetsAudioPlayer.stop();
  }

  static stopAndPlayFunc(String filePath) {
    _assetsAudioPlayer.stop().then((value) {
      playUrlFunc(filePath);
    });
    Future.delayed(Duration(milliseconds: 500));
  }

  static playUrlFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.network(filePath));
  }

  static playFileFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.file(filePath));
  }

  static playFunc() {
    _assetsAudioPlayer.play();
  }

  static pauseFunc() {
    _assetsAudioPlayer.pause();
  }

  static playOrPauseFunc() {
    _assetsAudioPlayer.playOrPause();
  }

  static seekFunc(Duration pos) {
    _assetsAudioPlayer.seek(pos);
  }

  // static seekToFunc(Duration pos){
  //   _assetsAudioPlayer.seek
  // }

  static Stream getCurrentStream() {
    return _assetsAudioPlayer.current;
  }

  static Stream getPositionStream() {
    return _assetsAudioPlayer.currentPosition;
  }

  static Stream getSongLengthStream() {
    return _assetsAudioPlayer.realtimePlayingInfos;
  }

  static AssetsAudioPlayer assetsAudioPlayer() {
    return _assetsAudioPlayer;
  }
}
