import 'package:flutter/material.dart';

import 'package:music_minorleague/model/view/page/artist_news/component/artist_news_banner_widget.dart';

import 'component/important_artist_widget.dart';

class ArtistNewsPage extends StatefulWidget {
  @override
  _ArtistNewsPageState createState() => _ArtistNewsPageState();
}

class _ArtistNewsPageState extends State<ArtistNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar();
  }

  _body() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArtistNewsBannerWidget(),
          ImportantArtistWidget(),
        ],
      ),
    );
  }
}
