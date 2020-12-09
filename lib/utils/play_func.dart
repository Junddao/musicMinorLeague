import 'package:assets_audio_player/assets_audio_player.dart';

class PlayMusic {
  static AssetsAudioPlayer _assetsAudioPlayer = new AssetsAudioPlayer();
  static makeNewPlayer() {
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }

  static stopFunc() {
    _assetsAudioPlayer.stop();
  }

  static playUrlFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.network(filePath));
  }

  static playFileFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.file(filePath));
  }

  static playListFunc(List<Audio> audios) {
    _assetsAudioPlayer.open(
      Playlist(
        audios: audios,
      ),
      loopMode: LoopMode.playlist,
    );
  }

  static next() {
    _assetsAudioPlayer.next();
  }

  static previous() {
    _assetsAudioPlayer.previous();
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
