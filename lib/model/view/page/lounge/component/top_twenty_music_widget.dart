import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class TopTwentyMusicWidget extends StatefulWidget {
  final List<MusicInfoData> _topTwentyMusicList;
  final Function playOrpauseMusic;
  final Function visibleMiniPlayer;
  TopTwentyMusicWidget(
      this._topTwentyMusicList, this.playOrpauseMusic, this.visibleMiniPlayer);

  @override
  _TopTwentyMusicWidgetState createState() => _TopTwentyMusicWidgetState();
}

class _TopTwentyMusicWidgetState extends State<TopTwentyMusicWidget> {
  @override
  Widget build(BuildContext context) {
    final itemSize = 120.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
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
      widget._topTwentyMusicList == null ||
              widget._topTwentyMusicList.length == 0
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
                itemCount: widget._topTwentyMusicList.length,
                itemBuilder: (context, index) {
                  final item = widget._topTwentyMusicList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Transform.translate(
                      offset: Offset(20.0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          width: 120,
                          height: 120,
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
                                child: InkWell(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 1, color: Colors.white)),
                                    child: Icon(
                                      Provider.of<NowPlayMusicProvider>(context,
                                                          listen: false)
                                                      .isPlay ==
                                                  true &&
                                              widget._topTwentyMusicList[index]
                                                      .id ==
                                                  Provider.of<NowPlayMusicProvider>(
                                                          context,
                                                          listen: false)
                                                      .nowMusicId
                                          ? FontAwesomeIcons.pause
                                          : FontAwesomeIcons.play,
                                      color: Provider.of<NowPlayMusicProvider>(
                                                          context,
                                                          listen: false)
                                                      .isPlay ==
                                                  true &&
                                              widget._topTwentyMusicList[index]
                                                      .id ==
                                                  Provider.of<NowPlayMusicProvider>(
                                                          context,
                                                          listen: false)
                                                      .nowMusicId
                                          ? MColors.kakao_yellow
                                          : MColors.white,
                                      size: 8,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      widget.playOrpauseMusic(
                                          widget._topTwentyMusicList[index]);
                                      // playOrPauseMusic(index);
                                    });
                                  },
                                ),
                              ),
                              Center(
                                child: Container(
                                    height: 100,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      // border: Border.all(
                                      //     color: MColors.white, width: 1),
                                    ),
                                    child: // 마케팅
                                        Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.title,
                                          style: MTextStyles.bold14White,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          item.artist,
                                          style: MTextStyles.regular12White,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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

  // void playOrPauseMusic(int index) {
  //   Provider.of<NowPlayMusicProvider>(context, listen: false).musicInfoData =
  //       widget._topTwentyMusicList[index];

  //   String nowId =
  //       Provider.of<NowPlayMusicProvider>(context, listen: false).nowMusicId;

  //   int selectedValue; // 0 : first Selected , 1: same song selected, 2: different song selected

  //   // first selected
  //   if (nowId == null) {
  //     nowId = widget._topTwentyMusicList[index].id;
  //     selectedValue = 0;
  //   }
  //   // same song selected
  //   else if (nowId == widget._topTwentyMusicList[index].id) {
  //     Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay = false;

  //     selectedValue = 1;
  //   }

  //   // different song selected
  //   else if (nowId != null && nowId != widget._topTwentyMusicList[index].id) {
  //     nowId = widget._topTwentyMusicList[index].id;
  //     selectedValue = 2;
  //   }
  //   Provider.of<NowPlayMusicProvider>(context, listen: false).nowMusicId =
  //       nowId;

  //   setState(() {
  //     if (selectedValue == 0) {
  //       PlayMusic.playUrlFunc(
  //           Provider.of<NowPlayMusicProvider>(context, listen: false)
  //               .musicInfoData
  //               .musicPath);
  //     } else if (selectedValue == 2) {
  //       PlayMusic.stopFunc();

  //       widget._initSubscription();

  //       // _clearSubscriptions();
  //       PlayMusic.makeNewPlayer();

  //       PlayMusic.playUrlFunc(
  //           Provider.of<NowPlayMusicProvider>(context, listen: false)
  //               .musicInfoData
  //               .musicPath);
  //     } else if (selectedValue == 1) {
  //       PlayMusic.playOrPauseFunc();
  //     }

  //     widget.visibleMiniPlayer();
  //   });
  // }
}
