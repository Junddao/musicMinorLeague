import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
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
    tabController = TabController(initialIndex: 0, vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            labelPadding: EdgeInsets.only(left: 10, right: 10),
            labelStyle: MTextStyles.bold12Tomato,
            unselectedLabelStyle: MTextStyles.bold12PinkishGrey,
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
              Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 11.0),
                  child: Text(
                    '내가 찜한 음악',
                  )),
              // Container(
              //     alignment: Alignment.bottomCenter,
              //     padding: EdgeInsets.only(bottom: 11.0),
              //     child: Text(
              //       '모임',
              //     )),
              // Container(
              //     alignment: Alignment.bottomCenter,
              //     padding: EdgeInsets.only(bottom: 11.0),
              //     height: 30.0,
              //     child: Text ('마켓', )
              // ),
            ],
          ),
          TabBarView(controller: tabController, children: [
            _buildThisWeekNewPage(),
            _buildMyPickPage(),
            // _buildItemPage(),
            // Center(child:Text('준비중 입니다.')),
          ]),
        ],
      ),
    );
  }

  _buildThisWeekNewPage() {}

  _buildMyPickPage() {}
}
