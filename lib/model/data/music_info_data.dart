import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';

class MusicInfoData {
  String title;
  String musicPath;
  String imagePath;
  String dateTime;
  bool favorite;
  MusicTypeEnum musicTypeEnum;
  UserProfileData userProfileData;
  MusicInfoData({
    this.title,
    this.musicPath,
    this.imagePath,
    this.dateTime,
    this.favorite,
    this.userProfileData,
  });
}
