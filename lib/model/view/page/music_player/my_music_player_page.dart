import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:provider/provider.dart';

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

  _appBar() {
    return AppBar(
      title: Text(
        "Player",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
    );
  }

  _body() {
    return Container(
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // SizedBox(
            //   height: 50,
            // ),
            // Container(
            //   alignment: Alignment.topLeft,
            //   margin: EdgeInsets.only(
            //     left: 10,
            //   ),
            //   child: IconButton(
            //     onPressed: () {},
            //     icon: Icon(FontAwesomeIcons.chevronDown),
            //   ),
            // ),
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
                  image:
                      Provider.of<NowPlayMusicProvider>(context, listen: false)
                                  .musicInfoData
                                  .imagePath ==
                              null
                          ? Image.asset('assets/images/default_image.jpg')
                          : NetworkImage(Provider.of<NowPlayMusicProvider>(
                                  context,
                                  listen: false)
                              .musicInfoData
                              .imagePath),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              Provider.of<NowPlayMusicProvider>(context, listen: false)
                  .musicInfoData
                  .title,
              style: MTextStyles.bold20Black36,
            ),
            Text(Provider.of<NowPlayMusicProvider>(context, listen: false)
                .musicInfoData
                .artist),
            SizedBox(
              height: 20,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: MColors.tomato,
                inactiveTrackColor: MColors.warm_grey,
                trackHeight: 2.0,
                thumbColor: MColors.kakao_yellow,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayColor: Colors.purple.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                onChanged: (v) {},
                value: 10,
                max: 100,
                min: 0,
              ),
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
                    // color: MColors.tomato,
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
