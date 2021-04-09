import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

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
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        '아티스트 목록',
        style: MTextStyles.bold18Black,
      ),

      backgroundColor: Colors.transparent,
      elevation: 0.0,
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.search),
      //     onPressed: () {

      //     },
      //   ),
      // ],
    );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ArtistNewsBannerWidget(),
          ImportantArtistWidget(),
        ],
      ),
    );
  }
}
