import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    return true;
  }

  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((value) {
      if (value == true)
        _navigatorToHome();
      else {
        _navigatorToLogin();
      }
    });
  }

  void _navigatorToHome() {
    Navigator.of(context).pushNamed('TabPage');
  }

  void _navigatorToLogin() {
    Navigator.of(context).pushNamed('LoginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'J T B',
            style: MTextStyles.bold20Black36,
          ),
        ],
      ),
    );
  }
}
