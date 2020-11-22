import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';

class MusicInfoData {
  String title;
  String artist;
  String musicPath;
  String imagePath;
  String dateTime;
  int favoriteCnt;
  MusicTypeEnum musicTypeEnum;
  MusicInfoData({
    this.title,
    this.artist,
    this.musicPath,
    this.imagePath,
    this.dateTime,
    this.favoriteCnt,
    this.musicTypeEnum,
    // UserProfileData userProfileData;
  });
}
