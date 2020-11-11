import 'dart:ffi';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
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
      body: TabBarView(controller: tabController, children: [
        _buildThisWeekNewPage(),
        _buildBestTwenty(),
        // _buildMyPickPage(),
        // _buildItemPage(),
        // Center(child:Text('준비중 입니다.')),
      ]),
    );
  }

  _buildThisWeekNewPage() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          PlayWidget(),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    height: 72,
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
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateTime.now().month.toString() +
                                '월 ' +
                                DateTime.now().day.toString() +
                                '일',
                            style: MTextStyles.medium10PinkishGrey,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _buildBestTwenty() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                IconButton(icon: Icon(Icons.check), onPressed: null),
                Text(
                  '모두 선택',
                  style: MTextStyles.bold12PinkishGrey,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  // _buildMyPickPage() {}
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
                IconButton(icon: Icon(Icons.play_arrow), onPressed: null),
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
