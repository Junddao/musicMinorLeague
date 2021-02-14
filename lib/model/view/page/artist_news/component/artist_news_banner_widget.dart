import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/page/artist_news/component/MCirclePainter.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class ArtistNewsBannerWidget extends StatefulWidget {
  @override
  _ArtistNewsBannerWidgetState createState() => _ArtistNewsBannerWidgetState();
}

class _ArtistNewsBannerWidgetState extends State<ArtistNewsBannerWidget> {
  double currentBannerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 145,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: 3,
            itemBuilder: _buildBannerItem,
            onPageChanged: (page) {
              setState(() {
                currentBannerIndex = page.toDouble();
              });
            },
          ),
          Positioned(
            bottom: 8,
            right: 10,
            left: 10,
            child: DotsIndicator(
              dotsCount: 3,
              position: currentBannerIndex,
              decorator: DotsDecorator(
                size: Size(6, 6),
                activeSize: Size(6, 6),
                color: Color.fromRGBO(200, 200, 200, 0.3),
                activeColor: Colors.white,
                spacing: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBannerItem(BuildContext context, int index) {
    return Container(
        height: 145,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(0.5, 0),
                end: Alignment(0.5, 1),
                colors: [const Color(0xffff2e2e), const Color(0xfff26313)])),
        child: Padding(
          padding: EdgeInsets.only(
            top: 21,
            left: 20,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '배너제목',
                      style: MTextStyles.regular14White,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                    ),
                    Text(
                      '내용설명을\n입력하세요\n최대3줄까지',
                      style: MTextStyles.bold18White,
                    ),
                  ],
                ),
              ),
              CustomPaint(
                size: Size(139, 126),
                painter: MCirclePainter(MColors.white_two08),
              ),
            ],
          ),
        ));
  }
}
