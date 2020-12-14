import 'package:flutter/material.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';

class MiniWidgetStatusProvider with ChangeNotifier {
  LoungeBottomWidgets _bottomSeletListWidget = LoungeBottomWidgets.none;
  LoungeBottomWidgets _bottomPlayListWidget = LoungeBottomWidgets.none;

  LoungeBottomWidgets get bottomSeletListWidget => _bottomSeletListWidget;
  set bottomSeletListWidget(LoungeBottomWidgets bottomSeletListWidget) {
    _bottomSeletListWidget = bottomSeletListWidget;
    notifyListeners();
  }

  LoungeBottomWidgets get bottomPlayListWidget => _bottomPlayListWidget;
  set bottomPlayListWidget(LoungeBottomWidgets bottomSeletListWidget) {
    _bottomPlayListWidget = bottomSeletListWidget;
    notifyListeners();
  }
}
