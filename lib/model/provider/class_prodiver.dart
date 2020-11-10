// import 'dart:async';
// import 'package:music_minorleague/model/data/user_profile_data.dart';
// import 'package:music_minorleague/model/provider/api_Service.dart';
// import 'package:music_minorleague/model/provider/parent_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class ClassProvider extends ParentProvider {
//   // ApiService _api = ApiService();
//   UserProfileData userProfileData;
//   //사용자 정보 가져오기
//   Future<void> getUserProfile() async {
//     GoogleSignIn _googleSignIn = new GoogleSignIn();

//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     final GoogleSignIn googleSignIn = new GoogleSignIn();
//     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final FirebaseUser user =
//         (await _auth.signInWithCredential(credential)).user;

//     userProfileData
//     user

//   }
// }
