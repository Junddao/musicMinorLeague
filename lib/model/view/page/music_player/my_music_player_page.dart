import 'package:flutter/material.dart';

class MyMusicPlayerPage extends StatefulWidget {
  @override
  _MyMusicPlayerPageState createState() => _MyMusicPlayerPageState();
}

class _MyMusicPlayerPageState extends State<MyMusicPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {}

  _body() {}
}
