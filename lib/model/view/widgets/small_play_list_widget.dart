import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';

import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/model/view/widgets/position_seek_widget.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class SmallPlayListWidget extends StatefulWidget {
  const SmallPlayListWidget({
    Key key,
  }) : super(key: key);

  @override
  _SmallPlayListWidgetState createState() => _SmallPlayListWidgetState();
}

class _SmallPlayListWidgetState extends State<SmallPlayListWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Duration position = new Duration();
  Duration musicLength = new Duration();

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
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GestureDetector(
              onVerticalDragStart: (dragDetails) {
                startVerticalDragDetails = dragDetails;
              },
              onVerticalDragUpdate: (dragDetails) {
                updateVerticalDragDetails = dragDetails;
              },
              onVerticalDragEnd: (endDetails) {
                double dx = updateVerticalDragDetails.globalPosition.dx -
                    startVerticalDragDetails.globalPosition.dx;
                double dy = updateVerticalDragDetails.globalPosition.dy -
                    startVerticalDragDetails.globalPosition.dy;
                double velocity = endDetails.primaryVelocity;

                //Convert values to be positive
                if (dx < 0) dx = -dx;
                if (dy < 0) dy = -dy;

                if (velocity < 0) {
                  onSwipeUp();
                } else {
                  onSwipeDown();
                }
              },
              child: Container(
                  height: 100,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(8),
                    //   topRight: Radius.circular(8),
                    // ),
                    // border: Border.all(color: MColors.black, width: 1),

                    color: MColors.kakao_yellow,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey,
                    //     blurRadius: 1.0,
                    //   ),
                    // ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: StreamBuilder(
                            stream: PlayMusic.getCurrentStream(),
                            builder: (context, currentSnapshot) {
                              final Playing playing = currentSnapshot.data;
                              final Metas metas = playing?.audio?.audio?.metas;

                              final String currentMusicId =
                                  playing?.audio?.audio?.metas?.id;
                              if (currentSnapshot.hasError) {
                                return Center(
                                  child: Text('error'),
                                );
                              } else {
                                if (currentSnapshot.hasData) {
                                  switch (currentSnapshot.connectionState) {
                                    case ConnectionState.active:
                                      return _buildMusicPlayer(metas, playing);
                                    default:
                                      return SizedBox.shrink();
                                  }
                                } else {
                                  return SizedBox.shrink();
                                }
                              }
                            }),
                      ),
                      SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: StreamBuilder(
                              stream: PlayMusic.getSongLengthStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox.shrink();
                                } else if (!snapshot.hasData) {
                                  return SizedBox.shrink();
                                }

                                final RealtimePlayingInfos infos =
                                    snapshot.data;
                                position = infos.currentPosition;
                                musicLength = infos.duration;
                                return PositionSeekWidget(
                                    position: position,
                                    infos: infos,
                                    musicLength: musicLength);
                              }),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void onSwipeUp() {
    Navigator.of(context).pushNamed('MyMusicPlayerPage');
  }

  void onSwipeDown() {}

  Widget _buildMusicPlayer(Metas metas, Playing playing) {
    return StreamBuilder(
        stream: PlayMusic.isPlayingFunc(),
        builder: (context, playingSnapshot) {
          if (playingSnapshot.hasError) {
            return Center(
              child: Text('error'),
            );
          } else {
            if (playingSnapshot.hasData) {
              final isPlaying = playingSnapshot.data;
              switch (playingSnapshot.connectionState) {
                case ConnectionState.active:
                  return _buildPlayer(metas, playing, isPlaying);
                default:
                  return SizedBox.shrink();
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        });
  }

  Widget _buildPlayer(Metas metas, Playing playing, bool isPlaying) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          String collection = FirebaseDBHelper.userCollection;
          String doc = metas.extra['userId'];

          FirebaseDBHelper.getData(collection, doc).then((value) {
            UserProfileData otherUserProfileData =
                UserProfileData.fromMap(value.data());
            Navigator.of(context).pushNamed('OtherUserProfilePage',
                arguments: otherUserProfileData);
          });
        },
        child: ClipOval(
          // borderRadius:
          //     BorderRadius.circular(4.0),
          child: playing == null
              ? CircularProgressIndicator()
              : Hero(
                  tag: metas?.id,
                  child: ExtendedImage.network(
                    metas?.image?.path ??
                        'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg',
                    cache: true,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    clearMemoryCacheWhenDispose: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return SizedBox.shrink();
                          break;
                        case LoadState.completed:
                          _controller.forward();
                          return FadeTransition(
                            opacity: _controller,
                            child: ExtendedRawImage(
                              image: state.extendedImageInfo?.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              // scale: 1.0,
                            ),
                          );
                          break;
                        case LoadState.failed:
                          _controller.reset();
                          return Image.asset(
                              'assets/images/default_cover_Image.jpg');
                          break;
                      }
                    },
                  ),
                ),
        ),
      ),
      title: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('MyMusicPlayerPage');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metas?.title ?? '',
              maxLines: 1,
              style: MTextStyles.bold12Grey06,
              overflow: TextOverflow.ellipsis,
            ),
            // SizedBox(
            //   width: 6,
            // ),
            Text(
              metas?.artist ?? '',
              maxLines: 1,
              style: MTextStyles.regular10WarmGrey,
            ),
          ],
        ),
      ),
      trailing: Wrap(
        children: [
          IconButton(
            icon: Icon(
              Icons.skip_previous,
            ),
            // iconSize: 20,
            onPressed: () {
              PlayMusic.previous();
            },
          ),
          IconButton(
              // iconSize: 10,
              icon: Icon(isPlaying == true
                  ? FontAwesomeIcons.pause
                  : FontAwesomeIcons.play),
              color: isPlaying == true ? MColors.black : MColors.black,
              onPressed: () {
                PlayMusic.playOrPauseFunc();
              }),
          IconButton(
            icon: Icon(
              Icons.skip_next,
            ),
            // iconSize: 20,
            onPressed: () {
              PlayMusic.next();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.close,
            ),
            // iconSize: 20,
            onPressed: () {
              PlayMusic.stopFunc();
              PlayMusic.clearAudioPlayer();
              context.read<MiniWidgetStatusProvider>().bottomPlayListWidget =
                  BottomWidgets.none;
            },
          ),
        ],
      ),
    );
  }
}
