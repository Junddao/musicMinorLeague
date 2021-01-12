import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/view/page/music_player/component/main_player_position_seek_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/model/view/widgets/small_play_list_widget.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MyMusicPlayerPage extends StatefulWidget {
  @override
  _MyMusicPlayerPageState createState() => _MyMusicPlayerPageState();
}

class _MyMusicPlayerPageState extends State<MyMusicPlayerPage> {
  List<MusicInfoData> selectedMusicList;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  _body() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  child: StreamBuilder<Object>(
                      stream: PlayMusic.getCurrentStream(),
                      builder: (context, currentSnapshot) {
                        final Playing playing = currentSnapshot.data;
                        final Metas metas = playing?.audio?.audio?.metas;

                        return StreamBuilder(
                            stream: PlayMusic.isPlayingFunc(),
                            builder: (context, playingSnapshot) {
                              final isPlaying = playingSnapshot.data;
                              return Column(
                                children: <Widget>[
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x46000000),
                                          offset: Offset(0, 10),
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
                                        image: ExtendedNetworkImageProvider(
                                          metas?.image?.path ??
                                              'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg',
                                          cache: true,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    metas?.title ?? '',
                                    style: MTextStyles.bold16Black,
                                  ),
                                  Text(metas?.artist ?? '',
                                      style: MTextStyles.regular12WarmGrey),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: StreamBuilder(
                                          stream:
                                              PlayMusic.getSongLengthStream(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return SizedBox.shrink();
                                            }

                                            final RealtimePlayingInfos infos =
                                                snapshot.data;
                                            position = infos.currentPosition;
                                            musicLength = infos.duration;
                                            return MainPlayerPositionSeekWidget(
                                                position: position,
                                                infos: infos,
                                                musicLength: musicLength);
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          PlayMusic.previous();
                                        },
                                        icon: Icon(Icons.skip_previous),
                                      ),
                                      IconButton(
                                        iconSize: 40,
                                        onPressed: () {
                                          setState(() {
                                            PlayMusic.playOrPauseFunc();
                                          });
                                        },
                                        icon: Icon(
                                          isPlaying == true
                                              ? FontAwesomeIcons.pause
                                              : FontAwesomeIcons.play,
                                          // color: MColors.tomato,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          PlayMusic.next();
                                        },
                                        icon: Icon(Icons.skip_next),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      }),
                ),

                SizedBox(
                  height: 30,
                ),
                // Divider(
                //   height: 20,
                //   // thickness: 2,
                //   indent: 20,
                //   endIndent: 20,
                // ),
                Expanded(
                  child: StreamBuilder(
                      stream: PlayMusic.getCurrentStream(),
                      builder: (context, currentSnapshot) {
                        if (currentSnapshot.hasData == null) {
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          final Playing playing = currentSnapshot.data;
                          return ListView.builder(
                            itemCount: playing?.playlist?.audios?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = playing.playlist.audios[index].metas;
                              return ListTile(
                                tileColor: index == playing.index
                                    ? MColors.grey_06
                                    : Colors.transparent,
                                onTap: () {
                                  PlayMusic.playlistPlayAtIndex(index);
                                  context
                                          .read<MiniWidgetStatusProvider>()
                                          .bottomPlayListWidget =
                                      BottomWidgets.miniPlayer;
                                },
                                leading: ClipOval(
                                  // borderRadius:
                                  //     BorderRadius.circular(4.0),
                                  child: Image(
                                    image: ExtendedNetworkImageProvider(
                                      item?.image?.path ??
                                          'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg',
                                      cache: true,
                                    ),
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Column(
                                  children: [
                                    Text(
                                      item.title,
                                      style: index == playing.index
                                          ? MTextStyles.bold14White
                                          : MTextStyles.bold14Grey06,
                                    ),
                                    Text(
                                      item.artist,
                                      style: MTextStyles
                                          .regular12WarmGrey_underline,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }

                        // return ListView.builder(
                        //   itemCount: audios.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     final item = audios[index].metas.title;
                        //     return Text(item);
                        //   },
                        // );
                      }),
                )
              ],
            ),
            Visibility(
              visible: Provider.of<MiniWidgetStatusProvider>(context)
                          .bottomPlayListWidget ==
                      BottomWidgets.miniPlayer
                  ? true
                  : false,
              child: SmallPlayListWidget(),
            ),
          ],
        ),
      ),
    );
    // }
  }
}
