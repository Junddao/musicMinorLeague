import 'package:music_minorleague/model/data/url_info.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class PageName {
  static String overWatch = 'overwatch';
  static String leagueOfLegend = 'clien';
}

class InkWellDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: new Text('Junddao'),
            accountEmail: new Text('y2hunter@gmail.com'),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('J'),
            ),
          ),
          new ListTile(
            title: new Text('오버워치'),
            onTap: () => selectPage(context, PageName.overWatch),
          ),
          new Divider(),
          new ListTile(
            title: new Text('리그 오브 레전드'),
            onTap: () => selectPage(context, PageName.leagueOfLegend),
          ),
          new Divider(),
          new ListTile(
            title: new Text('닫기'),
            trailing: new Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void selectPage(BuildContext context, String pageName) {
    if (pageName == PageName.overWatch)
      Provider.of<UrlInfo>(context).url =
          'https://m.ppomppu.co.kr/new/hot_bbs.php';
    if (pageName == PageName.leagueOfLegend)
      Provider.of<UrlInfo>(context).url =
          'https://m.clien.net/service/recommend';

    Navigator.of(context).pop();
  }
}
