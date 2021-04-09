import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/banner_data.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';

class ArtistNewsBannerWidget extends StatefulWidget {
  @override
  _ArtistNewsBannerWidgetState createState() => _ArtistNewsBannerWidgetState();
}

class _ArtistNewsBannerWidgetState extends State<ArtistNewsBannerWidget> {
  double currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
    return StreamBuilder(
        stream: FirebaseDBHelper.getDataStream("banner"),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<BannerData> bannerDatas =
              FirebaseDBHelper.getBannerDatas(snapshot.data);
          return Container(
              height: 145,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    bannerDatas[index].image,
                    cache: true,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
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
                            bannerDatas[index].title,
                            style: MTextStyles.regular14White,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 3),
                          ),
                          Container(
                            width: SizeConfig.screenWidth * 0.5,
                            child: Text(
                              bannerDatas[index].subTitle,
                              maxLines: 3,
                              style: MTextStyles.bold18White,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
