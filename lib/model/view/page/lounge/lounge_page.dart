import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

import 'component/small_select_list_widget.dart';

enum BottomWidgets {
  miniSelectList,
  miniPlayer,
  none,
}

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  int playMusicIndex;
  BottomWidgets bottomWidget = BottomWidgets.none;
  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicInfoList;

  MusicInfoData dummy1 = new MusicInfoData(
      dateTime: '123',
      favorite: true,
      imagePath: 'imagepath',
      musicPath: 'path',
      title: 'title',
      userProfileData: UserProfileProvider().userProfileData);
  MusicInfoData dummy2 = new MusicInfoData(
      dateTime: '234',
      favorite: true,
      imagePath: 'imagepath',
      musicPath: 'path',
      title: 'title2',
      userProfileData: UserProfileProvider().userProfileData);

  List<MusicInfoData> thisWeekMusicList;
  List<bool> selectedList;
  List<bool> isPlayList;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);

    isTabThisWeekMusicListItem = false;
    musicInfoList = new List<MusicInfoData>();

    //TODO: get music list from firebase store
    thisWeekMusicList = new List<MusicInfoData>();
    thisWeekMusicList.add(dummy1);
    thisWeekMusicList.add(dummy2);
    selectedList = List.generate(thisWeekMusicList.length, (index) => false);
    isPlayList = List.generate(thisWeekMusicList.length, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '라운지',
          style: MTextStyles.bold18Black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(43),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              labelPadding: EdgeInsets.only(left: 10, right: 10),
              labelStyle: MTextStyles.bold14Tomato,
              unselectedLabelStyle: MTextStyles.bold14PinkishGrey,
              controller: tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: MColors.tomato),
                insets: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: MColors.tomato,
              unselectedLabelColor: MColors.pinkish_grey,
//                      isScrollable: true,
              tabs: [
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 11.0),
                    child: Text(
                      '이번주 음악',
                    )),
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 11.0),
                    child: Text(
                      '베스트 20',
                    )),
                // Container(
                //     alignment: Alignment.bottomCenter,
                //     padding: EdgeInsets.only(bottom: 11.0),
                //     child: Text(
                //       '내가 찜한 음악',
                //     )),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildThisWeekNewPage(),
          _buildBestTwenty(),
        ],
      ),
    );
  }

  _buildThisWeekNewPage() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          PlayWidget(),
          Expanded(
            child: Stack(
              children: [
                playListOfThisWeek(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded playListOfThisWeek() {
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
              itemCount: thisWeekMusicList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 72,
                  color: selectedList[index] == true
                      ? Colors.grey[300]
                      : Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        selectedList[index] = !selectedList[index];
                        selectedList.contains(true)
                            ? bottomWidget = BottomWidgets.miniSelectList
                            : bottomWidget = BottomWidgets.none;
                      });
                    },
                    leading: CircleAvatar(),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'aaa',
                          style: MTextStyles.bold14Grey06,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'bbb',
                          maxLines: 1,
                          style: MTextStyles.regular12WarmGrey_underline,
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            icon: Icon(
                              isPlayList[index] == true
                                  ? Icons.pause
                                  : Icons.play_arrow_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                playMusicIndex = index;
                                bottomWidget = BottomWidgets.miniPlayer;
                                isPlayList[index] = !isPlayList[index];
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              size: 16,
                            ),
                            onPressed: null),
                      ],
                    ),
                  ),
                );
              }),
          Visibility(
            visible:
                bottomWidget == BottomWidgets.miniSelectList ? true : false,
            child: SmallSelectListWidget(
                thisWeekMusicList: thisWeekMusicList,
                selectedList: selectedList),
          ),
          Visibility(
            visible: bottomWidget == BottomWidgets.miniPlayer ? true : false,
            child: SmallPlayListWidget(
              isPlayList: isPlayList,
              thisWeekMusicList: thisWeekMusicList,
              playMusicIndex: playMusicIndex,
            ),
          ),
        ],
      ),
    );
  }

  _buildBestTwenty() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          PlayWidget(),
          playListOfThisWeek(),
        ],
      ),
    );
  }
}

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
                  'aaa',
                  style: MTextStyles.bold14Grey06,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'bbb',
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

class PlayWidget extends StatelessWidget {
  const PlayWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            IconButton(icon: Icon(Icons.check), onPressed: null),
            Text(
              '전체선택',
              style: MTextStyles.bold12PinkishGrey,
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                IconButton(icon: Icon(Icons.shuffle), onPressed: null),
                Text(
                  '셔플재생',
                  style: MTextStyles.bold12PinkishGrey,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                    icon: Icon(Icons.play_arrow_outlined), onPressed: null),
                Text(
                  '전체재생',
                  style: MTextStyles.bold12PinkishGrey,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
