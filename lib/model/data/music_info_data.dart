import 'package:music_minorleague/model/data/user_profile_data.dart';

class MusicInfoData {
  String title;
  String musicPath;
  String imagePath;
  String dateTime;
  bool favorite;
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
