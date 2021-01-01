import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/model/enum/viewstate.dart';

import '../exceptions.dart';

const DEFAULT_TIMEOUT_SEC = 10;

class ApiParent with ChangeNotifier {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  setStateBusy() {
    _state = ViewState.Busy;
    notifyListeners();
  }

  setStateIdle() {
    _state = ViewState.Idle;
    notifyListeners();
  }

  bool isSuccess(int responseCode) {
    return responseCode != null && 200 <= responseCode && responseCode < 300;
  }

  dynamic throwException(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data().toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.data().toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data().toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
