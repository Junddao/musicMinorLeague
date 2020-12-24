import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/page/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    String collection = FirebaseDBHelper.allMusicCollection;
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseDBHelper.getDataStream(collection),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('error'),
              );
            } else if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Provider.of<NowPlayMusicProvider>(context).musicList =
                  FirebaseDBHelper.getMusicDatabase(snapshot.data);

              Provider.of<NowPlayMusicProvider>(context).musicList.length > 20
                  ? Provider.of<NowPlayMusicProvider>(context).twentyList =
                      Provider.of<NowPlayMusicProvider>(context)
                          .musicList
                          .sublist(0, 20)
                  : Provider.of<NowPlayMusicProvider>(context).twentyList =
                      Provider.of<NowPlayMusicProvider>(context).musicList;
              return TabPage();
            }
          }),
    );
  }
}
