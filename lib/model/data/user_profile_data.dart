import 'dart:convert';

class UserProfileData {
  final String userName;
  final String photoUrl;
  final String userEmail;
  final String id;
  final String youtubeUrl;
  final String introduce;
  UserProfileData(
    this.userName,
    this.photoUrl,
    this.userEmail,
    this.id,
    this.youtubeUrl,
    this.introduce,
  );

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'photoUrl': photoUrl,
      'userEmail': userEmail,
      'id': id,
      'youtubeUrl': youtubeUrl,
      'introduce': introduce,
    };
  }

  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserProfileData(
      map['userName'],
      map['photoUrl'],
      map['userEmail'],
      map['id'],
      map['youtubeUrl'],
      map['introduce'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileData.fromJson(String source) =>
      UserProfileData.fromMap(json.decode(source));
}
