import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_minorleague/model/data/default_url.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  final firestoreinstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
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
            Positioned(
              bottom: 50,
              left: (SizeConfig.screenWidth - SizeConfig.screenWidth * 0.7) / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Container(
                    width: SizeConfig.screenWidth * 0.7,
                    child: Align(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: MColors.tomato,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.google,
                                color: MColors.white,
                              ),
                              SizedBox(width: 10.0),
                              Text('Google로 로그인',
                                  style: MTextStyles.bold14White),
                            ],
                          ),
                          onPressed: signInWithGoogle,
                        )),
                  ),
                  SizedBox(height: 10.0),
                  Platform.isIOS
                      ? Container(
                          width: SizeConfig.screenWidth * 0.7,
                          child: Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                color: MColors.black,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.apple,
                                      color: MColors.white,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text('Apple로 로그인',
                                        style: MTextStyles.bold14White),
                                  ],
                                ),
                                onPressed: () async {
                                  await signInWithApple();
                                }),
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 10.0),
                  Container(
                    width: SizeConfig.screenWidth * 0.7,
                    child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: MColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: MColors.black,
                              ),
                              SizedBox(width: 10.0),
                              Text('다른 방법으로 로그인',
                                  style: MTextStyles.bold14Black),
                            ],
                          ),
                          onPressed: () async {
                            await signInwithEmail();
                          }),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.center,
                    width: 250.0,
                    child: InkWell(
                        onTap: () async {
                          await signInWithGuest();
                        },
                        child: Text('Guest로 둘러보기',
                            style: MTextStyles.bold12White)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  updateDatabase(Map<String, dynamic> userProfileData) {
    String doc = userProfileData['userEmail'];
    FirebaseDBHelper.setData(
        FirebaseDBHelper.userCollection, doc, userProfileData);
    // firestoreinstance.collection('User').doc(_id).set(data);
  }

  void _navigatorToOnBoardingScreen() {
    Navigator.of(context).pushNamed('OnBoardingScreenPage');
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;

    String collection = FirebaseDBHelper.userCollection;
    String doc = user.email;

    FirebaseDBHelper.getData(collection, doc).then((value) {
      if (value.exists == true) {
        Provider.of<UserProfileProvider>(context, listen: false)
            .userProfileData = UserProfileData.fromMap(value.data());

        // updateDatabase(value.data());
      } else {
        Map<String, dynamic> userProfileData = {
          'userName': user.displayName ?? 'empty',
          'photoUrl': user.photoURL ?? '',
          'userEmail': user.email,
          'id': user.email, // id
          'youtubeUrl': '',
          'introduce': '',
          'backgroundPhotoUrl': '',
        };

        Provider.of<UserProfileProvider>(context, listen: false)
            .userProfileData = UserProfileData.fromMap(userProfileData);

        updateDatabase(userProfileData);
      }
    });

    // Navigator.of(context).pushNamed('TabPage');
    _navigatorToOnBoardingScreen();
  }

  Future<void> signInWithApple() async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // webAuthenticationOptions: WebAuthenticationOptions(
      //   // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
      //   clientId: 'musicMinorleague.jtb.com',
      //   redirectUri: Uri.parse(
      //     'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
      //   ),
      // ),
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );
    final User user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    print(credential);

    String collection = FirebaseDBHelper.userCollection;
    String doc = user.email;

    FirebaseDBHelper.getData(collection, doc).then((value) {
      if (value.exists == true) {
        Provider.of<UserProfileProvider>(context, listen: false)
            .userProfileData = UserProfileData.fromMap(value.data());

        // updateDatabase(value.data());
      } else {
        Map<String, dynamic> userProfileData = {
          'userName': user.displayName ?? 'empty',
          'photoUrl': user.photoURL ?? '',
          'userEmail': user.email,
          'id': user.email, // id
          'youtubeUrl': '',
          'introduce': '',
          'backgroundPhotoUrl': '',
        };

        Provider.of<UserProfileProvider>(context, listen: false)
            .userProfileData = UserProfileData.fromMap(userProfileData);

        updateDatabase(userProfileData);
      }
    });

    // Navigator.of(context).pushNamed('TabPage');
    _navigatorToOnBoardingScreen();
  }

  signInWithGuest() {
    Map<String, dynamic> userProfileData = {
      'userName': 'Guest',
      'photoUrl': DefaultUrl.default_image_url,
      'userEmail': '',
      'id': 'Guest', // id
      'youtubeUrl': '',
      'introduce': '',
      'backgroundPhotoUrl': '',
    };

    Provider.of<UserProfileProvider>(context, listen: false).userProfileData =
        UserProfileData.fromMap(userProfileData);

    // updateDatabase(userProfileData);

    Navigator.of(context).pushNamed('TabPage');
  }

  signInwithEmail() {
    Navigator.of(context).pushNamed('EmailLoginPage');
  }
}
