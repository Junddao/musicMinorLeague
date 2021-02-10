import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';

import 'package:music_minorleague/model/view/style/textstyles.dart';

class OnboardingScreenPage extends StatefulWidget {
  @override
  _OnboardingScreenPageState createState() => _OnboardingScreenPageState();
}

class _OnboardingScreenPageState extends State<OnboardingScreenPage> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF5B16D0) : Color(0x1a5B16D0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        setState(() {
          print("You can not get out of here! kkk");
        });
        return Future(() => false);
      },
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     stops: [0.1, 0.4, 0.7, 0.9],
            //     colors: [
            //       Color(0xFF3594DD),
            //       Color(0xFF4563DB),
            //       Color(0xFF5036D5),
            //       Color(0xFF5B16D0),
            //     ],
            //   ),
            // ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        _navigatorToTabPage();
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: MColors.black,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight * 0.7,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: SvgPicture.asset(
                                  'assets/images/onboarding0.svg',
                                  height: SizeConfig.screenHeight * 0.3,
                                  width: SizeConfig.screenHeight * 0.3,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                '자신의 음악을\n모두에게 들려주세요.',
                                style: MTextStyles.bold18Black,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                '당신이 만든 음악을 모두에게 들려줄 수 있는 공간입니다.',
                                style: MTextStyles.regular14BlackColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: SvgPicture.asset(
                                  'assets/images/onboarding1.svg',
                                  height: SizeConfig.screenHeight * 0.3,
                                  width: SizeConfig.screenHeight * 0.3,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                '저작권에 주의하세요.',
                                style: MTextStyles.bold18Black,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                '기존 가수의 음악 또는 커버곡 등록은 문제될 수 있어요.',
                                style: MTextStyles.regular14BlackColor,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: SvgPicture.asset(
                                  'assets/images/onboarding2.svg',
                                  height: SizeConfig.screenHeight * 0.3,
                                  width: SizeConfig.screenHeight * 0.3,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                '자신의 음악을 마음껏 홍보하세요.',
                                style: MTextStyles.bold18Black,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                '메이저리그로 가기 위한 발판으로\n저희를 활용하세요.',
                                style: MTextStyles.regular14BlackColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  _currentPage != _numPages - 1
                      ? Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: FlatButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: MColors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: MColors.black,
                                    size: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: _currentPage == _numPages - 1
            ? GestureDetector(
                onTap: () {
                  print('Get started');
                  _navigatorToTabPage();
                },
                child: Container(
                  height: SizeConfig.screenHeight * 0.1,
                  width: double.infinity,
                  color: Color(0xFF5B16D0),
                  child: Center(
                    child: Text(
                      '시작하기!',
                      style: TextStyle(
                        color: MColors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : Text(''),
      ),
    );
  }

  void _navigatorToTabPage() {
    Navigator.of(context).pushNamed('TabPage');
  }
}
