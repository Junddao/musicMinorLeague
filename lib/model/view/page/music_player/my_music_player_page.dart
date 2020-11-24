import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';

class MyMusicPlayerPage extends StatefulWidget {
  @override
  _MyMusicPlayerPageState createState() => _MyMusicPlayerPageState();
}

class _MyMusicPlayerPageState extends State<MyMusicPlayerPage> {
  bool _isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {}

  _body() {
    return Container(
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                left: 10,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.chevronDown),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x46000000),
                    offset: Offset(0, 20),
                    spreadRadius: 0,
                    blurRadius: 30,
                  ),
                  BoxShadow(
                    color: Color(0x11000000),
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/3552948/pexels-photo-3552948.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Album Title",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text("Singer Name, Label"),
            SizedBox(
              height: 20,
            ),
            Slider(
              onChanged: (v) {},
              value: 10,
              max: 100,
              min: 0,
              activeColor: Color(0xFF5E35B1),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.backward),
                ),
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  icon: Icon(
                    _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                    color: Color(0xFF5E35B1),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
