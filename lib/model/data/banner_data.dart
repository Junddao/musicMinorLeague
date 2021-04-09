import 'dart:convert';

class BannerData {
  String title;
  String subTitle;
  String image;
  BannerData({
    this.title,
    this.subTitle,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subTitle': subTitle,
      'image': image,
    };
  }

  factory BannerData.fromMap(Map<String, dynamic> map) {
    return BannerData(
      title: map['title'],
      subTitle: map['subTitle'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerData.fromJson(String source) =>
      BannerData.fromMap(json.decode(source));

  @override
  String toString() =>
      'BannerData(title: $title, subTitle: $subTitle, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BannerData &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.image == image;
  }

  @override
  int get hashCode => title.hashCode ^ subTitle.hashCode ^ image.hashCode;
}
