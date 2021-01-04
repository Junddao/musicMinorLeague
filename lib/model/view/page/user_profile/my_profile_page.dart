import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  List<MusicInfoData> _musicList;
  List<MusicInfoData> _myMusicList;
  int topFavoriteNum = 0;
  int myRank = 0;

  @override
  void initState() {
    _myMusicList = new List<MusicInfoData>();
    _musicList = new List<MusicInfoData>();
    super.initState();
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
      automaticallyImplyLeading: false,
      title: Text(
        '마이 페이지',
        style: MTextStyles.bold18Black,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  _body() {
    String url =
        Provider.of<UserProfileProvider>(context).userProfileData.youtubeUrl;
    SizeConfig().init(context);
    return SingleChildScrollView(
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
                if (_musicList[i].userId ==
                    Provider.of<UserProfileProvider>(context)
                        .userProfileData
                        .id) {
                  topFavoriteNum = _musicList[i].favorite;
                  myRank = i + 1;
                  break;
                }
              }

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 100,
                      width: SizeConfig.screenWidth,
                      child: Image.network(
                        Provider.of<UserProfileProvider>(context)
                            .userProfileData
                            .photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
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
                                      Provider.of<UserProfileProvider>(
                                        context,
                                      ).userProfileData.photoUrl,
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
                                      width: SizeConfig.screenWidth - 200,
                                      child: Text(
                                        Provider.of<UserProfileProvider>(
                                                context,
                                                listen: false)
                                            .userProfileData
                                            .userName,
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
                                    _launchURL(url);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 1, color: MColors.tomato)),
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
                            Provider.of<UserProfileProvider>(context)
                                    .userProfileData
                                    .introduce ??
                                '소개글은 프로필 편집에서 입력 가능합니다.',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 70,
                                    child: Column(
                                      children: [
                                        Text(
                                          '최고 추천수',
                                          style: MTextStyles.bold12Black,
                                        ),
                                        Text(
                                          topFavoriteNum.toString(),
                                          style: MTextStyles.bold12Black,
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
                                          style: MTextStyles.bold12Black,
                                        ),
                                        Text(
                                          myRank.toString() + ' 위',
                                          style: MTextStyles.bold12Black,
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
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('MyProfileModifyPage');
                                },
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          width: 1, color: MColors.tomato)),
                                  child: Center(
                                      child: Text(
                                    '프로필 편집',
                                    style: MTextStyles.bold12Tomato,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 40,
                        ),
                        Container(
                          height: 30,
                          child: StreamBuilder(
                              stream: FirebaseDBHelper.getMyMusicDataStream(
                                  FirebaseDBHelper.allMusicCollection,
                                  Provider.of<UserProfileProvider>(context)
                                      .userProfileData
                                      .id),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('error'),
                                  );
                                } else if (snapshot.hasData == false) {
                                  return Center(
                                    child: Text('no data'),
                                  );
                                } else {
                                  _myMusicList =
                                      FirebaseDBHelper.getMusicDatabase(
                                          snapshot.data);

                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '내가 등록한 노래',
                                        style: MTextStyles.bold16Black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        _myMusicList.length.toString() + '곡',
                                        style: MTextStyles.bold12Tomato,
                                      ),
                                    ],
                                  );
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('MyMusicModifyPage');
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: SizeConfig.screenWidth - 40,
                              decoration: BoxDecoration(
                                  color: MColors.tomato,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 1, color: MColors.tomato)),
                              child: Text(
                                '내 노래 편집',
                                style: MTextStyles.bold12White,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              );
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
}
