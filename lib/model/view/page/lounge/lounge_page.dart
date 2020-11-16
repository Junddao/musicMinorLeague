import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool isPlay;
  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicInfoList = new List<MusicInfoData>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    isPlay = false;
    isTabThisWeekMusicListItem = false;
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
          // _buildMyPickPage(),
          // _buildItemPage(),
          // Center(child:Text('준비중 입니다.')),
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
                // SmallPlayListWidget(isPlay: isPlay),
              ],
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

  Expanded playListOfThisWeek() {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              height: 72,
              child: ListTile(
                onTap: () {
                  // TODO : need to input real data.

                  UserProfileData userData =
                      UserProfileProvider().userProfileData;
                  MusicInfoData musicInfoData = new MusicInfoData(
                    title: 'aaa',
                    dateTime: 'time',
                    favorite: true,
                    path: 'path',
                    userProfileData: userData,
                  );
                  musicInfoList.add(musicInfoData);

                  setState(() {
                    Visibility(
                      visible: musicInfoList.length > 0 ? true : false,
                      child:
                          SmallSelectListWidget(musicInfoList: musicInfoList),
                    );
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
                          Icons.play_arrow_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            isPlay = true;
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
    );
  }
  // _buildMyPickPage() {}
}

class SmallSelectListWidget extends StatefulWidget {
  const SmallSelectListWidget({
    Key key,
    List<MusicInfoData> musicInfoList,
  })  : _musicInfoList = musicInfoList,
        super(key: key);

  final List<MusicInfoData> _musicInfoList;

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
            child: widget._musicInfoList == null
                ? SizedBox.shrink()
                : CircleAvatar(
                    radius: 15,
                    backgroundColor: MColors.tomato,
                    child: Text(
                      widget._musicInfoList.length.toString(),
                      style: MTextStyles.bold14White,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class SmallPlayListWidget extends StatefulWidget {
  const SmallPlayListWidget({
    Key key,
    isPlay,
  })  : _isPlay = isPlay,
        super(key: key);

  final bool _isPlay;

  @override
  _SmallPlayListWidgetState createState() => _SmallPlayListWidgetState();
}

class _SmallPlayListWidgetState extends State<SmallPlayListWidget> {
  @override
  void initState() {
    // TODO: implement initState
  }

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
                    icon: Icon(
                      Icons.play_arrow_outlined,
                    ),
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
