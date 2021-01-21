import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_minorleague/model/data/default_url.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColors.tomato,
        elevation: 0,
      ),
      body: FlutterLogin(
        title: 'J T B',
        onLogin: _loginUser,
        onSignup: _signUpUser,
        onSubmitAnimationCompleted: () async {
          FirebaseAuth _auth = FirebaseAuth.instance;
          User user = _auth.currentUser;
          user != null ? _navigatorToTabPage(user) : _showErrorPage();
        },
        onRecoverPassword: _recoveryPassword,
        messages: LoginMessages(
          forgotPasswordButton: '비밀번호를 잊으셨나요?',
          loginButton: '로그인',
          signupButton: '회원가입',
          recoverPasswordButton: '복구하기',
          goBackButton: '뒤로가기',
          recoverPasswordIntro: '',
          recoverPasswordDescription: '비밀번호 변경을 위해 등록하신 이메일로 메일을 발송합니다.',
        ),
        theme: LoginTheme(
          primaryColor: MColors.tomato,
          accentColor: Colors.yellow,
          errorColor: Colors.deepOrange,
          titleStyle: MTextStyles.bold24White,
          bodyStyle: TextStyle(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
          // textFieldStyle: TextStyle(
          //   color: Colors.orange,
          //   shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
          // ),
          buttonStyle: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 5,
            margin: EdgeInsets.only(top: 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
          ),
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.withOpacity(.1),
            contentPadding: EdgeInsets.zero,
            errorStyle: TextStyle(
              backgroundColor: Colors.orange,
              color: Colors.white,
            ),
            labelStyle: TextStyle(fontSize: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
              borderRadius: inputBorder,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
              borderRadius: inputBorder,
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 7),
              borderRadius: inputBorder,
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade400, width: 8),
              borderRadius: inputBorder,
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 5),
              borderRadius: inputBorder,
            ),
          ),
          buttonTheme: LoginButtonTheme(
            splashColor: Colors.purple,
            backgroundColor: MColors.tomato,
            highlightColor: Colors.lightGreen,
            elevation: 2.0,
            highlightElevation: 6.0,
          ),
        ),
      ),
    );
  }

  Future<String> _loginUser(LoginData loginData) {
    _handleSignIn(loginData.name.trim(), loginData.password)
        .then(
          (user) => Fluttertoast.showToast(
              msg: '환영합니다. ${user.email} 님',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              fontSize: 16),
        )
        .catchError(
          (e) => Fluttertoast.showToast(
              msg: '로그인에 실패하였습니다.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16),
        );
  }

  Future<User> _handleSignIn(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User _user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return _user;
  }

  Future<String> _signUpUser(LoginData loginData) {
    _handleSignUp(loginData.name.trim(), loginData.password)
        .then(
          (user) => Fluttertoast.showToast(
              msg: '환영합니다. ${user.email} 님',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              fontSize: 16),
        )
        .catchError(
          (e) => Fluttertoast.showToast(
              msg: '회원가입에 실패하였습니다.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16),
        );
  }

  Future<User> _handleSignUp(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final User _user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return _user;
  }

  Future<String> _recoveryPassword(String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.sendPasswordResetEmail(email: email).catchError((e) =>
        Fluttertoast.showToast(
            msg: '${e}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16));
  }

  _navigatorToTabPage(User user) {
    Map<String, dynamic> userProfileData = {
      'userName': user.email.substring(0, user.email.indexOf('@')),
      'photoUrl': DefaultUrl.default_image_url,
      'userEmail': user.email,
      'id': user.email.substring(0, user.email.indexOf('@')), // id
      'youtubeUrl': '',
      'introduce': '',
      'backgroundPhotoUrl': '',
    };

    Provider.of<UserProfileProvider>(context, listen: false).userProfileData =
        UserProfileData.fromMap(userProfileData);

    updateDatabase(userProfileData);

    Navigator.of(context).pushNamed('TabPage');
  }

  _showErrorPage() {
    // setState(() {
    Fluttertoast.showToast(msg: '등록되지 않은 사용자입니다.');
    Navigator.of(context).pop();
    // });
  }

  updateDatabase(Map<String, dynamic> userProfileData) {
    String doc = userProfileData['userEmail']
        .substring(0, userProfileData['userEmail'].indexOf('@'));
    FirebaseDBHelper.setData(
        FirebaseDBHelper.userCollection, doc, userProfileData);
    // firestoreinstance.collection('User').doc(_id).set(data);
  }
}
