import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';

class PlayMusic {
  static AssetsAudioPlayer _assetsAudioPlayer = new AssetsAudioPlayer();
  static makeNewPlayer() {
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }

  static stopFunc() {
    _assetsAudioPlayer.stop();
  }

  static playUrlFunc(MusicInfoData nowMusicData) {
    final audio = Audio.network(nowMusicData.musicPath,
        metas: Metas(
          title: nowMusicData.title,
          artist: nowMusicData.artist,
          image: MetasImage.network(nowMusicData.imagePath),
        ));
    _assetsAudioPlayer.open(audio, showNotification: true);
  }

  static playFileFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.file(filePath));
  }

// static playListFunc(List<Audio> audios) {
//     _assetsAudioPlayer.open(
//       Playlist(
//         audios: audios,
//       ),
//       loopMode: LoopMode.playlist,
//     );
//   }

  static playListFunc(List<MusicInfoData> selectedMusicList) {
    List<Audio> audios = List.generate(
        selectedMusicList.length,
        (index) => new Audio.network(selectedMusicList[index].musicPath,
            metas: Metas(
              title: selectedMusicList[index].title,
              artist: selectedMusicList[index].artist,
              image: MetasImage.network(selectedMusicList[index].imagePath),
            )));
    _assetsAudioPlayer.open(
      Playlist(
        audios: audios,
      ),
      loopMode: LoopMode.playlist,
      showNotification: true,
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
