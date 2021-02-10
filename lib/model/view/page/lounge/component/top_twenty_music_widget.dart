import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class TopTwentyMusicWidget extends StatefulWidget {
  final List<MusicInfoData> _topTwentyMusicList;
  final Function playOrpauseMusic;

  TopTwentyMusicWidget(this._topTwentyMusicList, this.playOrpauseMusic);

  @override
  _TopTwentyMusicWidgetState createState() => _TopTwentyMusicWidgetState();
}

class _TopTwentyMusicWidgetState extends State<TopTwentyMusicWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemSize = 120.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 40, bottom: 12.0),
        child: Row(
          children: [
            Text(
              '베스트 20',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MColors.blackColor),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                playOrPauseMusicForSelectedList();
              },
              child: Container(
                height: 20,
                // width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: MColors.tomato)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Center(
                      child: Row(
                    children: [
                      Text(
                        '베스트 20 모두재생 ',
                        style: MTextStyles.bold10Tomato,
                      ),
                      Icon(
                        Icons.play_circle_fill,
                        color: MColors.tomato,
                        size: 10,
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ],
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
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Transform.translate(
                      offset: Offset(0.0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: StreamBuilder(
                            stream: PlayMusic.getCurrentStream(),
                            builder: (context, currentSnapshot) {
                              final Playing playing = currentSnapshot.data;

                              final String currentMusicId =
                                  playing?.audio?.audio?.metas?.id;
                              return StreamBuilder(
                                  stream: PlayMusic.isPlayingFunc(),
                                  builder: (context, playingSnapshot) {
                                    final isPlaying = playingSnapshot.data;
                                    return InkWell(
                                      onTap: () {
                                        String collection =
                                            FirebaseDBHelper.userCollection;
                                        String doc = widget
                                            ._topTwentyMusicList[index].userId;

                                        FirebaseDBHelper.getData(
                                                collection, doc)
                                            .then((value) {
                                          UserProfileData otherUserProfileData =
                                              UserProfileData.fromMap(
                                                  value.data());
                                          Navigator.of(context).pushNamed(
                                              'OtherUserProfilePage',
                                              arguments: otherUserProfileData);
                                        });
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned.fill(
                                                child: item.imagePath == null
                                                    ? Container()
                                                    : ExtendedImage.network(
                                                        item.imagePath,
                                                        fit: BoxFit.cover,
                                                        cache: true,
                                                        loadStateChanged:
                                                            (ExtendedImageState
                                                                state) {
                                                          switch (state
                                                              .extendedImageLoadState) {
                                                            case LoadState
                                                                .loading:
                                                              return SizedBox
                                                                  .shrink();
                                                              break;
                                                            case LoadState
                                                                .completed:
                                                              _controller
                                                                  .forward();
                                                              return FadeTransition(
                                                                opacity:
                                                                    _controller,
                                                                child:
                                                                    ExtendedRawImage(
                                                                  image: state
                                                                      .extendedImageInfo
                                                                      ?.image,

                                                                  fit: BoxFit
                                                                      .cover,
                                                                  // scale: 1.0,
                                                                ),
                                                              );
                                                              break;
                                                            case LoadState
                                                                .failed:
                                                              _controller
                                                                  .reset();
                                                              return Image.asset(
                                                                  'assets/images/default_cover_Image.jpg');
                                                              break;
                                                          }
                                                        },
                                                      )),
                                            Container(
                                              color: const Color(0x66000000),
                                            ),
                                            Positioned(
                                              right: 10,
                                              bottom: 10,
                                              child: GestureDetector(
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white)),
                                                  child: Icon(
                                                    isPlaying == true &&
                                                            widget
                                                                    ._topTwentyMusicList[
                                                                        index]
                                                                    .id ==
                                                                currentMusicId
                                                        ? FontAwesomeIcons.pause
                                                        : FontAwesomeIcons.play,
                                                    color: isPlaying == true &&
                                                            widget
                                                                    ._topTwentyMusicList[
                                                                        index]
                                                                    .id ==
                                                                currentMusicId
                                                        ? MColors.kakao_yellow
                                                        : MColors.white,
                                                    size: 8,
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    widget.playOrpauseMusic(
                                                        widget._topTwentyMusicList[
                                                            index],
                                                        currentMusicId);
                                                    // playOrPauseMusic(index);
                                                  });
                                                },
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                  height: 100,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    // border: Border.all(
                                                    //     color: MColors.white, width: 1),
                                                  ),
                                                  child: // 마케팅
                                                      Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: MTextStyles
                                                            .bold14White,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        item.artist,
                                                        style: MTextStyles
                                                            .regular12White,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                      ),
                    ),
                  );
                },
              ),
            ),
    ]);
  }

  void playOrPauseMusicForSelectedList() {
    PlayMusic.stopFunc().whenComplete(() {
      PlayMusic.clearAudioPlayer();
      PlayMusic.makeNewPlayer();
      PlayMusic.playListFunc(widget._topTwentyMusicList).then((value) {
        Provider.of<MiniWidgetStatusProvider>(context, listen: false)
            .bottomPlayListWidget = BottomWidgets.miniPlayer;
      });
    });
  }
}
