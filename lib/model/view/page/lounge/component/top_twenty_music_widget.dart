import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class TopTwentyMusicWidget extends StatelessWidget {
  final List<MusicInfoData> _musicList;
  TopTwentyMusicWidget(this._musicList);

  @override
  Widget build(BuildContext context) {
    final itemSize = 100.0;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40, bottom: 12.0),
            child: Text(
              'Top 20 ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MColors.blackColor),
            ),
          ),
          _musicList == null || _musicList.length == 0
              ? Container(
                  height: itemSize,
                  child: Center(child: Text('Top 20 노래가 없습니다.😢')),
                )
              : Container(
                  height: itemSize,
                  width: double.infinity,
                  // color: Colors.yellow,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _musicList.length,
                    itemBuilder: (context, index) {
                      final item = _musicList[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Transform.translate(
                          offset: Offset(20.0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                      child: item.imagePath == null
                                          ? Container()
                                          : Image.network(
                                              item.imagePath,
                                              fit: BoxFit.cover,
                                            )),
                                  Container(
                                    color: const Color(0x66000000),
                                  ),
                                  Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: Icon(
                                        FontAwesomeIcons.play,
                                        color: MColors.white_three08,
                                        size: 18,
                                      )),
                                  Center(
                                    child: Container(
                                        height: 40,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          // border: Border.all(
                                          //     color: MColors.white, width: 1),
                                        ),
                                        child: // 마케팅
                                            Column(
                                          children: [
                                            Text(item.artist,
                                                style: MTextStyles.bold10White,
                                                textAlign: TextAlign.center),
                                            Text(item.title,
                                                style: MTextStyles.bold10White,
                                                textAlign: TextAlign.center),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ]);
  }
}
