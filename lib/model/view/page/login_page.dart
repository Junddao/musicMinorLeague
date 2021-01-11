import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  final firestoreinstance = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;

    Map<String, dynamic> userProfileData = {
      'userName': user.displayName,
      'photoUrl': user.photoURL,
      'userEmail': user.email,
      'id': user.email.substring(0, user.email.indexOf('@')), // id
      'youtubeUrl': '',
      'introduce': '',
      'backgroundPhotoUrl': '',
    };

    Provider.of<UserProfileProvider>(context, listen: false).userProfileData =
        UserProfileData.fromMap(userProfileData);

    updateDatabase(userProfileData);

    // Navigator.of(context).pushNamed('TabPage');
    _navigatorToOnBoardingScreen();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/loginImage.jpg'),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  width: 250.0,
                  child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.google,
                              color: Color(0xffCE107C),
                            ),
                            SizedBox(width: 10.0),
                            Text('Google 아이디로 로그인',
                                style: MTextStyles.bold14Black),
                          ],
                        ),
                        onPressed: signInWithGoogle,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  updateDatabase(Map<String, dynamic> userProfileData) {
    String doc = userProfileData['userEmail']
        .substring(0, userProfileData['userEmail'].indexOf('@'));
    FirebaseDBHelper.setData(
        FirebaseDBHelper.userCollection, doc, userProfileData);
    // firestoreinstance.collection('User').doc(_id).set(data);
  }

  void _navigatorToOnBoardingScreen() {
    Navigator.of(context).pushNamed('OnBoardingScreenPage');
  }
}
