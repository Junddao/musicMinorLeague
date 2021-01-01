import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
      child: Stack(
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
                              width: SizeConfig.screenWidth - 60,
                              child: Text(
                                Provider.of<UserProfileProvider>(context,
                                        listen: false)
                                    .userProfileData
                                    .userName,
                                style: MTextStyles.bold14Black,
                                overflow: TextOverflow.ellipsis,
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
                                borderRadius: BorderRadius.circular(100),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          child: Column(
                            children: [
                              Text(
                                '받은 추천수',
                                style: MTextStyles.bold10Black,
                              ),
                              Text(
                                '123',
                                style: MTextStyles.bold10Black,
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
                                style: MTextStyles.bold10Black,
                              ),
                              Text(
                                '3' + ' 위',
                                style: MTextStyles.bold10Black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('MyProfileModifyPage');
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(width: 1, color: MColors.tomato)),
                        child: Center(
                            child: Text(
                          '프로필 편집',
                          style: MTextStyles.bold12Tomato,
                        )),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 40,
                ),
                Row(
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
                      '3곡',
                      style: MTextStyles.bold12Tomato,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('MyMusicModifyPage');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: SizeConfig.screenWidth - 40,
                      decoration: BoxDecoration(
                          color: MColors.tomato,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1, color: MColors.tomato)),
                      child: Text(
                        '내 노래 편집',
                        style: MTextStyles.bold12White,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
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
