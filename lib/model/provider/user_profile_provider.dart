import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileData _userProfileData;

  UserProfileData get userProfileData => _userProfileData;
  set userProfileData(UserProfileData userProfileData) {
    _userProfileData = userProfileData;
    notifyListeners();
  }
}
