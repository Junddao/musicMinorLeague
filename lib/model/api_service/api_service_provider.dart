import 'package:music_minorleague/model/data/send_file.dart';
import 'package:music_minorleague/model/provider/parent_provider.dart';

import 'api_service.dart';

class ApiServiceProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<bool> bunnyCdnUploadFile(
      SendFile data, String path, String filename) async {
    final _callUri = path + '/';
    final result = await _api.multipart(
      _callUri,
      data.toMap(),
      data.filePath,
      filename,
    );

    return isSuccess(result['HttpCode']);
  }
}
