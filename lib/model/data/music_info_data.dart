import 'package:music_minorleague/model/data/user_profile_data.dart';

class MusicInfoData {
  String title;
  String path;
  String dateTime;
  bool favorite;
  UserProfileData userProfileData;
  MusicInfoData({
    this.title,
    this.path,
    this.dateTime,
    this.favorite,
    this.userProfileData,
  });
}
