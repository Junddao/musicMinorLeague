import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';

import 'model/data/user_profile_data.dart';
import 'model/provider/user_profile_provider.dart';
import 'model/view/style/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User _user;
  Future<bool> _mockCheckForSession() async {
    bool result = false;

    await Future.delayed(Duration(milliseconds: 2000), () {
      _user = FirebaseAuth.instance.currentUser;
      _user != null ? result = true : result = false;
    });
    return result;
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
    // UserProfileData userProfileData = new UserProfileData(
    //   _user.displayName,
    //   _user.photoURL,
    //   _user.email,
    //   _user.email.substring(0, _user.email.indexOf('@')), // id
    //   '',
    //   '',
    // );

    String collection = FirebaseDBHelper.userCollection;
    String doc = _user.email.substring(0, _user.email.indexOf('@'));

    FirebaseDBHelper.getData(collection, doc).then((value) {
      Provider.of<UserProfileProvider>(context, listen: false).userProfileData =
          UserProfileData.fromMap(value.data());
    });

    Navigator.of(context).pushNamed('TabPage');
  }

  void _navigatorToLogin() {
    Navigator.of(context).pushNamed('LoginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: MColors.white),
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
