import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

const AccessKey =
    'fd51a216-c0c2-4836-ab9bd06d7411-a816-4b1e'; //bunnycdn storage password

class ApiService {
  final String _baseUrl = 'https://storage.bunnycdn.com/mymusicstorage/';

  final Map<String, String> _headers = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    'AccessKey': AccessKey,
  };

  Future<dynamic> get(String _path) async {
    print('Api get : url $_path start.');

    final response = await Dio()
        .get('$_baseUrl' + '$_path', options: Options(headers: _headers))
        .timeout(Duration(seconds: 10));
    print('Api get : url $_path  done.');
    print('dio response = ${response.toString()}');

    return response.data;
  }

  Future<Map> multipart(
    String _path,
    Map map,
    String _filePath,
    String _filename,
  ) async {
    FormData formData = FormData.fromMap(map);

    MediaType mediaType;
    _filename.contains('_music')
        ? mediaType = MediaType('audio', 'mpeg')
        : mediaType = MediaType('image', 'jpeg');

    if (_filePath != null && _filePath.isNotEmpty)
      formData.files.add(
        MapEntry(
            "filePath",
            MultipartFile.fromFileSync(_filePath,
                filename: _filename, contentType: mediaType)),
      );

    final response = await Dio().put(
      '$_baseUrl' + '$_path' + _filename,
      data: formData,
      options: Options(
        headers: _headers,
        contentType: 'multipart/form-data',
      ),
    );

    print('dio response = ${response.toString()}');

    return response.data;
  }
}
