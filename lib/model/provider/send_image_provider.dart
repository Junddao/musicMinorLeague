import 'dart:convert';
import 'package:dio/dio.dart';

const AccessKey =
    'fd51a216-c0c2-4836-ab9bd06d7411-a816-4b1e'; //bunnycdn storage password

class SendImageProvider {
  final Map<String, String> _headers = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    'AccessKey': AccessKey,
  };
  final String _baseUrl = 'https://storage.bunnycdn.com/mymusicstorage/';
  Future<Map> sendImageData(
      SendImageData data, String userId, String imageName) async {
    final _callUri = userId + '/';
    final result = await multipart(
      _callUri,
      data.toMap(),
      data.image,
      imageName,
    );

    return result;
  }

  Future<Map> multipart(
    String _path,
    Map map,
    String image,
    String _imageNmae,
  ) async {
    final formData = FormData.fromMap(map);

    if (image != null && image.isNotEmpty)
      formData.files.add(
        MapEntry(
          "image",
          MultipartFile.fromFileSync(image),
        ),
      );

    final response = await Dio().put(
      '$_baseUrl' + '$_path' + '$_imageNmae',
      data: formData,
      options: Options(
        headers: _headers,
      ),
    );

    print('dio response = ${response.toString()}');

    return response.data;
  }
}

class SendImageData {
  String image;

  SendImageData({
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
    };
  }

  factory SendImageData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SendImageData(
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SendImageData.fromJson(String source) =>
      SendImageData.fromMap(json.decode(source));
}
