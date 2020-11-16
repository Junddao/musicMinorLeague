import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class SmallSelectListWidget extends StatefulWidget {
  const SmallSelectListWidget({
    Key key,
    List<MusicInfoData> thisWeekMusicList,
    List<bool> selectedList,
  })  : _thisWeekMusicList = thisWeekMusicList,
        _selectedList = selectedList,
        super(key: key);

  final List<MusicInfoData> _thisWeekMusicList;
  final List<bool> _selectedList;

  @override
  _SmallSelectListWidgetState createState() => _SmallSelectListWidgetState();
}

class _SmallSelectListWidgetState extends State<SmallSelectListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.play_arrow_outlined),
                          onPressed: null),
                      Text(
                        '선택 항목 재생',
                        style: MTextStyles.bold12PinkishGrey,
                      ),
                    ],
                  ),
                  VerticalDivider(
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Column(
                    children: [
                      IconButton(icon: Icon(Icons.add), onPressed: null),
                      Text(
                        '재생 목록 추가',
                        style: MTextStyles.bold12PinkishGrey,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: widget._thisWeekMusicList == null
                ? SizedBox.shrink()
                : CircleAvatar(
                    radius: 15,
                    backgroundColor: MColors.tomato,
                    child: Text(
                      widget._selectedList
                          .where((element) => element == true)
                          .length
                          .toString(),
                      style: MTextStyles.bold14White,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
