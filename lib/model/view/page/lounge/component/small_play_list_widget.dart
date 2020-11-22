import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class SmallPlayListWidget extends StatefulWidget {
  const SmallPlayListWidget({
    Key key,
    playMusicIndex,
    List<MusicInfoData> thisWeekMusicList,
    List<bool> isPlayList,
  })  : _playMusicIndex = playMusicIndex,
        _thisWeekMusicList = thisWeekMusicList,
        _isPlayList = isPlayList,
        super(key: key);

  final int _playMusicIndex;
  final List<MusicInfoData> _thisWeekMusicList;
  final List<bool> _isPlayList;

  @override
  _SmallPlayListWidgetState createState() => _SmallPlayListWidgetState();
}

class _SmallPlayListWidgetState extends State<SmallPlayListWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
          height: 80,
          width: SizeConfig.screenWidth - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            border: Border.all(color: Colors.black12, width: 1),
            color: Colors.white,
          ),
          child: ListTile(
            leading: CircleAvatar(),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Provider.of<NowPlayMusicProvider>(context, listen: false)
                          .musicInfoData
                          ?.title ??
                      '',
                  style: MTextStyles.bold14Grey06,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  Provider.of<NowPlayMusicProvider>(context, listen: false)
                          .musicInfoData
                          ?.artist ??
                      '',
                  maxLines: 1,
                  style: MTextStyles.regular12WarmGrey_underline,
                ),
              ],
            ),
            trailing: Wrap(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                    ),
                    onPressed: null),
                IconButton(
                    icon: Icon(widget._playMusicIndex != null
                        ? widget._isPlayList[widget._playMusicIndex]
                            ? Icons.pause
                            : Icons.play_arrow_outlined
                        : Icons.play_arrow_outlined),
                    onPressed: null),
                IconButton(
                    icon: Icon(
                      Icons.skip_next,
                    ),
                    onPressed: null),
              ],
            ),
          )),
    );
  }
}
