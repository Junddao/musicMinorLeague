import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:flutter/material.dart';

class OtherUserProfileProvider with ChangeNotifier {
  UserProfileData _otherUserProfileData;

  UserProfileData get otherUserProfileData => _otherUserProfileData;
  set otherUserProfileData(UserProfileData otherUserProfileData) {
    _otherUserProfileData = otherUserProfileData;
    notifyListeners();
  }
}
