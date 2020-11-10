// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';
// import 'package:dio/dio.dart' as dio;

// class ApiService {
//   final String _baseUrl = 'http://54.180.101.226';

//   final Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   };

//   // var client = new http.Client();
//   Future<dynamic> get(String _path) async {
//     final token = await Util.getSharedString(KEY_TOKEN);
//     print(token);
//     _headers['Authorization'] = 'Bearer $token';

//     print('Api get : url $_path start.');
//     var responseJson;
//     try {
//       final response = await http
//           .get(Uri.encodeFull('$_baseUrl$_path'), headers: _headers)
//           .timeout(Duration(seconds: 10));
//       print('Api get : url $_path  done.');
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }

//   // Map QueryParameter call
//   Future<dynamic> getParam(String _path, Map<String, String> _data) async {
//     final token = await Util.getSharedString(KEY_TOKEN);
//     print(token);
//     _headers['Authorization'] = 'Bearer $token';

//     print('Api getParam : url $_path  ${_data.toString()} start.');
//     // String _queryParameters = json.encode(_data?.toMap() ?? {});

//     var responseJson;
//     try {
//       final uri = Uri.http(_baseUrl, _path, _data);

//       responseJson = await http
//           .get(Uri.encodeFull(uri.toString()), headers: _headers)
//           .timeout(Duration(seconds: 10));
//       print('Api get : url $_path  done. code : ${responseJson.body}');
//       //responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     } catch (e) {
//       throw FetchDataException(e);
//       // return responseJson;
//     }
//     return responseJson;
//   }

//   Future<dynamic> post(String _path, dynamic _data) async {
//     final token = await Util.getSharedString(KEY_TOKEN);
//     _headers['Authorization'] = 'Bearer $token';
//     var responseJson;
//     print('Api post : url $_path start.');
//     try {
//       //별도의 클래스 생성없이 map을 보내도 가능하도록 수정 1008 경준.
//       final map = (_data is Map ? _data : _data?.toMap()) ?? {};
//       String _body = json.encode(map);
//       // final uri = Uri.http(_baseUrl, _path);
//       final response = await http
//           .post(Uri.encodeFull('$_baseUrl$_path'),
//               body: _body, headers: _headers)
//           .timeout(Duration(seconds: 10));
//       print('Api post : url $_path  done. code : ${response.body}');
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     } catch (e) {
//       throw FetchDataException(e.toString());
//     }
//     return responseJson;
//   }

//   Future<dynamic> put(String _path, dynamic _data) async {
//     print('Api put : url $_path start.');
//     final token = await Util.getSharedString(KEY_TOKEN);
//     _headers['Authorization'] = 'Bearer $token';
//     var responseJson;

//     try {
//       //   String _body = jsonEncode(_data);
//       final map = (_data is Map ? _data : _data?.toMap()) ?? {};
//       String _body = json.encode(map);
//       print('Api put : _body : $_body');
//       // final uri = Uri.http(_baseUrl, _path);
//       final response = await http
//           .put(Uri.encodeFull('$_baseUrl$_path'),
//               body: _body, headers: _headers)
//           .timeout(Duration(seconds: 10));
//       print('Api put : _body return : ${response.body}');
//       responseJson = _response(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     print('Api put : url $_path  done.');
//     return responseJson;
//   }

//   Future<bool> imageUpload(
//       String _path, Map<String, dynamic> paramMap, File photoPath) async {
//     print('Api imageUpload : url $_path start.');
//     final token = await Util.getSharedString(KEY_TOKEN);
//     _headers['Content-Type'] = 'multipart/form-data';
//     // _headers['X-Requested-With'] = 'XMLHttpRequest';
//     _headers['Authorization'] = 'Bearer $token';
//     bool responseJson;
//     print('Api imageUpload :  photoPath.path ${photoPath.path}');
//     try {
//       final uri = Uri.http(_baseUrl, _path);

//       var request = http.MultipartRequest(
//           "POST", Uri.parse(Uri.encodeFull(uri.toString())));

//       paramMap.forEach((k, v) {
//         request.fields[k] = v;
//         print('$k : $v');
//       });
//       request.files.add(http.MultipartFile(
//           'photo',
//           File(photoPath.path).readAsBytes().asStream(),
//           File(photoPath.path).lengthSync(),
//           filename: photoPath.path.split("/").last));

//       http.StreamedResponse response =
//           await request.send().timeout(Duration(seconds: 30));
//       var responseByteArray = await response.stream.toBytes();
//       print('Api imageUpload : url $_path  $responseByteArray done. ');
//       return json.decode(utf8.decode(responseByteArray));
//     } on SocketException {
//       //FetchDataException('No Internet connection');
//       print('SocketException error ! ');
//       return false;
//     } catch (e) {
//       print('e : ' + e.toString());
//       return false;
//       //  FetchDataException(e);
//     }
//     print('Api imageUpload : url $_path  done.');
//     // return responseJson;
//   }

//   Future<dynamic> delete(String _path, Map<String, dynamic> _data) async {
//     final token = await Util.getSharedString(KEY_TOKEN);
//     _headers['Authorization'] = 'Bearer $token';
//     var responseJson;
//     try {
//       print('Api delete : url $_path start.');

//       final url = Uri.parse(_baseUrl + _path);
//       final request = http.Request("DELETE", url);
//       request.headers.addAll(_headers);
//       request.body = json.encode(_data); // jsonEncode(_data);
//       final streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//       //  var result = await response.stream.bytesToString();

//       print('Api delete : url $_path  response : .' + response.body);
//       responseJson = _response(response);
//       print('Api delete : url $_path  done. responseJson : $responseJson');
//       return responseJson;
//     } on SocketException {
//       print('No net');
//       throw FetchDataException('No Internet connection');
//     }

//     // return apiResponse;
//   }

//   Future<bool> multipart(String _path, Map map, List<String> fileList, {bool isPut = false}) async {
//     final token = await Util.getSharedString(KEY_TOKEN);
//     final formData = FormData.fromMap(map);
//     formData.files.addAll(List.generate(
//       fileList.length,
//       (index) => MapEntry(
//         "photos",
//         MultipartFile.fromFileSync(fileList[index], filename: "file$index"),
//       ),
//     ));

//     var response;

//     if(isPut){
//       response = await Dio().put(
//         '$_baseUrl$_path',
//         data: formData,
//         options: Options(
//           headers: {'Authorization': 'Bearer $token'},
//         ),
//       );
//     } else {
//       response = await Dio().post(
//         '$_baseUrl$_path',
//         data: formData,
//         options: Options(
//           headers: {'Authorization': 'Bearer $token'},
//         ),
//       );
// }

//     print('dio response = ${response.toString()}');
//     return response?.data['result'] ?? false;
//   }

//   Future<dynamic> multipartMap(String _path, Map map, Map fileMap) async {
//     final entryList = <MapEntry<String, MultipartFile>>[];
//     fileMap.forEach((key, value) {
//       entryList.add(MapEntry(key, MultipartFile.fromFileSync(value, filename: key)));
//     });

//     final token = await Util.getSharedString(KEY_TOKEN);
//     final formData = FormData.fromMap(map);
//     formData.files.addAll(entryList);

//     final response = await Dio().put(
//       '$_baseUrl$_path',
//       data: formData,
//       options: Options(
//         headers: {'Authorization': 'Bearer $token'},
//       ),
//     );

//     print('dio response = ${response.toString()}');
//     return response;
//   }

//   dynamic _response(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//       case 201:
//         var responseJson = json.decode(response.body.toString());
//         return responseJson;
//       case 400:
//         throw BadRequestException(json.decode(response.body)['message']);
//       case 401:
//       case 403:
//         throw UnauthorisedException(json.decode(response.body)['message']);
//       case 500:

//       default:
//         throw FetchDataException(json.decode(response.body)['message']);
//     }
//   }
// }

// class FetchDataException extends CustomException {
//   FetchDataException([String message])
//       : super(message, "Error During Communication: ");
// }

// class BadRequestException extends CustomException {
//   BadRequestException([message]) : super(message, "");
// }

// class UnauthorisedException extends CustomException {
//   UnauthorisedException([message]) : super(message, "");
// }

// class InvalidInputException extends CustomException {
//   InvalidInputException([String message]) : super(message, "");
// }

// class CustomException implements Exception {
//   final _message;
//   final _prefix;

//   CustomException([this._message, this._prefix]);

//   String toString() {
//     return "$_prefix$_message";
//   }
// }
