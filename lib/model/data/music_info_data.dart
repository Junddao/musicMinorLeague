import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';

import 'package:music_minorleague/model/enum/music_type_enum.dart';

class MusicInfoData {
  int sqliteId;
  String id;
  String title;
  String artist;
  String musicPath;
  String imagePath;
  String dateTime;
  int favorite;
  MusicTypeEnum musicType;
  MusicInfoData({
    this.sqliteId,
    this.id,
    this.title,
    this.artist,
    this.musicPath,
    this.imagePath,
    this.dateTime,
    this.favorite,
    this.musicType,
    // UserProfileData userProfileData;
  });

  Map<String, dynamic> toMap() {
    return {
      'sqliteId': sqliteId,
      'id': id,
      'title': title,
      'artist': artist,
      'musicPath': musicPath,
      'imagePath': imagePath,
      'dateTime': dateTime,
      'favorite': favorite,
      'musicType': EnumToString.convertToString(musicType),
    };
  }

  factory MusicInfoData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MusicInfoData(
      sqliteId: map['sqliteId'],
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      musicPath: map['musicPath'],
      imagePath: map['imagePath'],
      dateTime: map['dateTime'],
      favorite: map['favorite'],
      musicType:
          EnumToString.fromString(MusicTypeEnum.values, map['musicType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicInfoData.fromJson(String source) =>
      MusicInfoData.fromMap(json.decode(source));
}
