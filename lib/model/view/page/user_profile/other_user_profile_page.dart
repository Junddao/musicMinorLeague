import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';

import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';

import 'package:url_launcher/url_launcher.dart';

class OtherUserProfilePage extends StatefulWidget {
  const OtherUserProfilePage({
    Key key,
    @required this.otherUserProfile,
  }) : super(key: key);

  final UserProfileData otherUserProfile;
  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  List<MusicInfoData> _musicList;
  List<MusicInfoData> _myMusicList;
  int topFavoriteNum = 0;
  int myRank = 0;

  int selectedIndex;

  @override
  void initState() {
    _myMusicList = new List<MusicInfoData>();
    _musicList = new List<MusicInfoData>();
    super.initState();
  }

  @override
  void dispose() {
    // 나갈때 노래 끄기
    stopMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.otherUserProfile.userName + '님의 페이지',
        style: MTextStyles.bold18Black,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  _body() {
    String url = widget.otherUserProfile?.youtubeUrl;
    SizeConfig().init(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight,
      ),
      child: StreamBuilder(
          stream: FirebaseDBHelper.getDataStream(
              FirebaseDBHelper.allMusicCollection),
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
              _musicList = FirebaseDBHelper.getMusicDatabase(snapshot.data);
              _musicList.sort((a, b) => b.favorite.compareTo(a.favorite));

              for (int i = 0; i < _musicList.length; i++) {
                if (_musicList[i].userId == widget.otherUserProfile.id) {
                  topFavoriteNum = _musicList[i].favorite;
                  myRank = i + 1;
                  break;
                }
              }

              return StreamBuilder(
                  stream: FirebaseDBHelper.getMyMusicDataStream(
                      FirebaseDBHelper.allMusicCollection,
                      widget.otherUserProfile.id),
                  builder: (context, myDataSnapshot) {
                    if (myDataSnapshot.hasError) {
                      return Center(
                        child: Text('error'),
                      );
                    } else if (myDataSnapshot.hasData == false) {
                      return Center(
                        child: Text('no data'),
                      );
                    } else {
                      _myMusicList = FirebaseDBHelper.getMusicDatabase(
                          myDataSnapshot.data);
                      return Stack(
                        children: [
                          Positioned(
                            top: 0,
                            child: Container(
                              height: 100,
                              width: SizeConfig.screenWidth,
                              child: Image.network(
                                widget.otherUserProfile.photoUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  height: 180,
                                  width: SizeConfig.screenWidth,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 50,
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          child: ClipOval(
                                            child: Image.network(
                                              widget.otherUserProfile?.photoUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 120,
                                        left: 100,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width:
                                                  SizeConfig.screenWidth - 200,
                                              child: Text(
                                                widget
                                                    .otherUserProfile.userName,
                                                style: MTextStyles.bold14Black,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 120,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            if (url != null) _launchURL(url);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    width: 1,
                                                    color: MColors.tomato)),
                                            child: Icon(
                                              FontAwesomeIcons.youtube,
                                              size: 15,
                                              color: MColors.tomato,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.otherUserProfile.introduce ??
                                        '아직 소개글을 입력하지 않으셨습니다.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: MTextStyles.regular12Black,
                                  ),
                                ),
                                Divider(
                                  height: 40,
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 70,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '최고 추천수',
                                                  style:
                                                      MTextStyles.bold12Black,
                                                ),
                                                Text(
                                                  topFavoriteNum.toString(),
                                                  style:
                                                      MTextStyles.bold12Black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 70,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '추천 순위',
                                                  style:
                                                      MTextStyles.bold12Black,
                                                ),
                                                Text(
                                                  myRank.toString() + ' 위',
                                                  style:
                                                      MTextStyles.bold12Black,
                                                ),
                                                // Text(
                                                //   ' (총 ' +
                                                //       _musicList.length.toString() +
                                                //       '곡)',
                                                //   style: MTextStyles.bold10Black,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 40,
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.screenWidth * 0.5,
                                        child: Text(
                                          widget.otherUserProfile.userName +
                                              '님이 등록한 노래',
                                          style: MTextStyles.bold16Black,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        _myMusicList.length.toString() + '곡',
                                        style: MTextStyles.bold16Tomato,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  // height: 400,
                                  child: StreamBuilder(
                                      stream: PlayMusic.getCurrentStream(),
                                      builder: (context, currentSnapshot) {
                                        if (currentSnapshot.hasData == null) {
                                          return Container(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        } else {
                                          final Playing playing =
                                              currentSnapshot.data;
                                          return ListView.builder(
                                            itemCount: _myMusicList.length,
                                            itemBuilder: (context, index) {
                                              final item = _myMusicList[index];
                                              return StreamBuilder(
                                                  stream:
                                                      PlayMusic.isPlayingFunc(),
                                                  builder: (context,
                                                      playingSnapshot) {
                                                    final isPlaying =
                                                        playingSnapshot.data;
                                                    return ListTile(
                                                      tileColor: index ==
                                                              selectedIndex
                                                          ? MColors.grey_06
                                                          : Colors.transparent,
                                                      onTap: () {
                                                        setState(() {
                                                          if (selectedIndex ==
                                                              index) {
                                                            stopMusic();
                                                            selectedIndex =
                                                                null;
                                                          } else {
                                                            playOrPauseMusicForSelectedList(
                                                                _myMusicList[
                                                                    index]);
                                                            selectedIndex =
                                                                index;
                                                          }
                                                        });
                                                      },
                                                      leading: ClipOval(
                                                        // borderRadius:
                                                        //     BorderRadius.circular(4.0),
                                                        child: ExtendedImage
                                                            .network(
                                                          item.imagePath,
                                                          cache: true,
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                          clearMemoryCacheWhenDispose:
                                                              false,
                                                        ),
                                                      ),
                                                      title: Column(
                                                        children: [
                                                          Text(
                                                            item.title,
                                                            style: index ==
                                                                    selectedIndex
                                                                ? MTextStyles
                                                                    .bold14White
                                                                : MTextStyles
                                                                    .bold14Grey06,
                                                          ),
                                                          Text(
                                                            item.artist,
                                                            style: MTextStyles
                                                                .regular12WarmGrey_underline,
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: selectedIndex ==
                                                              index
                                                          ? isPlaying == true
                                                              ? Icon(
                                                                  Icons
                                                                      .music_note,
                                                                  color: MColors
                                                                      .white,
                                                                )
                                                              : CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                                  // value: 10.0,
                                                                )
                                                          : SizedBox.shrink(),
                                                    );
                                                  });
                                            },
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  });
            }
          }),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void stopMusic() {
    PlayMusic.stopFunc();
  }

  void playOrPauseMusicForSelectedList(MusicInfoData selectedMusic) {
    PlayMusic.stopFunc().whenComplete(() {
      PlayMusic.clearAudioPlayer();
      PlayMusic.makeNewPlayer();
      PlayMusic.playUrlFunc(selectedMusic);
    });
  }
}
