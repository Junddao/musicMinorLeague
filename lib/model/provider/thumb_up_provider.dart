import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:music_minorleague/model/data/user_profile_data.dart';

class ThumbUpProvider with ChangeNotifier {
  ThumbUpData _thumbUpData;

  ThumbUpData get thumbUpData => _thumbUpData;
  set thumbUpData(ThumbUpData thumbUpData) {
    _thumbUpData = thumbUpData;
    notifyListeners();
  }
}

class ThumbUpData {
  int todayCnt;
  ThumbUpData({
    this.todayCnt,
  });

  Map<String, dynamic> toMap() {
    return {
      'todayCnt': todayCnt,
    };
  }

  factory ThumbUpData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ThumbUpData(
      todayCnt: map['todayCnt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThumbUpData.fromJson(String source) =>
      ThumbUpData.fromMap(json.decode(source));
}
