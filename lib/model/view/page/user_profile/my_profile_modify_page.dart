import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/upload/component/upload_result_dialog.dart';

import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';

import 'component/my_profile_modify_cancel_Dialog.dart';

class MyProfileModifyPage extends StatefulWidget {
  @override
  _MyProfileModifyPageState createState() => _MyProfileModifyPageState();
}

class _MyProfileModifyPageState extends State<MyProfileModifyPage> {
  TextEditingController _nameTextEditingController;
  TextEditingController _introduceTextEditingController;
  TextEditingController _youtubeUrlTextEditingController;

  Reference ref;
  final firestoreinstance = FirebaseFirestore.instance;
  String imageFileUrl;

  File _profileImage;

  final picker = ImagePicker();
  @override
  void initState() {
    _nameTextEditingController = new TextEditingController();
    _introduceTextEditingController = new TextEditingController();
    _youtubeUrlTextEditingController = new TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _introduceTextEditingController.dispose();
    _youtubeUrlTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () async {
                MyProfileModifyCancelDialog.showCancelDialog(context)
                    .then((value) {
                  setState(() {
                    if (value == true) Navigator.pop(context);
                  });
                });
                //
              },
              child: Text(
                '취소',
                style: MTextStyles.medium14WarmGrey,
              )),
          Center(
            child: Text(
              '프로필 수정',
              style: MTextStyles.bold16Black2,
            ),
          ),
          FlatButton(
            onPressed: () async {
              // must attach image and music file.
              await upload();
            },
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: MColors.tomato, width: 1),
                  color: MColors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  '등록',
                  style: MTextStyles.bold14Tomato,
                ),
              ),
            ),
            // onPressed: () {},
          ),
        ],
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 100,
              width: SizeConfig.screenWidth,
              child: _profileImage == null
                  ? Image.network(
                      Provider.of<UserProfileProvider>(context)
                          .userProfileData
                          .photoUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _profileImage,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // Positioned(
          //   top: 60,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Container(
          //       alignment: Alignment.center,
          //       height: 30,
          //       width: 100,
          //       decoration: BoxDecoration(
          //           color: MColors.tomato_10,
          //           borderRadius: BorderRadius.circular(16),
          //           border: Border.all(width: 1, color: MColors.white)),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(
          //             Icons.camera_alt,
          //             color: Colors.white,
          //             size: 16,
          //           ),
          //           SizedBox(
          //             width: 8,
          //           ),
          //           Text('배경 편집', style: MTextStyles.bold12White),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  height: 180,
                  width: SizeConfig.screenWidth,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 50,
                        child: Container(
                          height: 100,
                          width: 100,
                          child: ClipOval(
                            child: _profileImage == null
                                ? Image.network(
                                    Provider.of<UserProfileProvider>(context)
                                        .userProfileData
                                        .photoUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _profileImage,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 70,
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: MColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1, color: MColors.brownish_grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: MColors.brownish_grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '이름 변경',
                    style: MTextStyles.bold16Black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: MColors.pinkish_grey, width: 1)),
                  child: TextField(
                    style: MTextStyles.regular12Black,
                    controller: _nameTextEditingController
                      ..text = _nameTextEditingController.text == ''
                          ? Provider.of<UserProfileProvider>(context)
                              .userProfileData
                              .userName
                          : _nameTextEditingController.text,
                    decoration: InputDecoration(
                      hintText: "아티스트님의 이름을 입력해주세요..",
                      hintStyle: MTextStyles.medium16WhiteThree,
                      labelStyle: TextStyle(color: Colors.transparent),
                      suffixIcon: IconButton(
                        onPressed: () => _nameTextEditingController.clear(),
                        icon: Icon(
                          Icons.clear,
                          size: 16,
                          color: MColors.pinkish_grey,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '내 소개',
                    style: MTextStyles.bold16Black,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: MColors.pinkish_grey, width: 1)),
                  child: TextField(
                    style: MTextStyles.regular12Black,
                    controller: _introduceTextEditingController
                      ..text = _introduceTextEditingController.text == ''
                          ? (Provider.of<UserProfileProvider>(context)
                                  .userProfileData
                                  .introduce ??
                              '')
                          : _introduceTextEditingController.text,
                    decoration: InputDecoration(
                      hintText: '자신의 소개글을 입력해 주세요.',
                      hintStyle: MTextStyles.medium16WhiteThree,
                      labelStyle: TextStyle(color: Colors.transparent),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            _introduceTextEditingController.clear(),
                        icon: Icon(
                          Icons.clear,
                          size: 16,
                          color: MColors.pinkish_grey,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'SNS',
                    style: MTextStyles.bold16Black,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 1, color: MColors.warm_grey)),
                      child: Icon(
                        FontAwesomeIcons.youtube,
                        size: 15,
                        color: MColors.warm_grey,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color: MColors.pinkish_grey, width: 1)),
                        child: TextField(
                          style: MTextStyles.regular12Black,
                          controller: _youtubeUrlTextEditingController
                            ..text = _youtubeUrlTextEditingController.text == ''
                                ? (Provider.of<UserProfileProvider>(context)
                                        .userProfileData
                                        .youtubeUrl ??
                                    '')
                                : _youtubeUrlTextEditingController.text,
                          decoration: InputDecoration(
                            hintText: 'Youtube 계정을 입력해 주세요.',
                            hintStyle: MTextStyles.medium16WhiteThree,
                            labelStyle: TextStyle(color: Colors.transparent),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  _youtubeUrlTextEditingController.clear(),
                              icon: Icon(
                                Icons.clear,
                                size: 16,
                                color: MColors.pinkish_grey,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> upload() async {
    await EasyLoading.show(
      status: 'uploading...',
      maskType: EasyLoadingMaskType.black,
    );

    await uploadImageFile();
  }

  Future<void> uploadImageFile() async {
    String _userId = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileData
        .id;
    String filename = 'profileImage';

    ref = FirebaseStorage.instance.ref().child(_userId).child(filename);

    if (_profileImage == null) {
      imageFileUrl = Provider.of<UserProfileProvider>(context, listen: false)
          .userProfileData
          .photoUrl;
      updateDatabase();
    } else {
      UploadTask uploadTask = ref.putFile(_profileImage);

      await uploadTask.then((TaskSnapshot snapshot) {
        snapshot.ref.getDownloadURL().then((fileUrl) {
          imageFileUrl = fileUrl;
          updateDatabase();
        });
      });
    }
  }

  updateDatabase() {
    if (_nameTextEditingController.text != null && imageFileUrl != null) {
      Map<String, dynamic> data = {
        'userName': _nameTextEditingController.text,
        'photoUrl': imageFileUrl,
        'youtubeUrl': _youtubeUrlTextEditingController.text,
        'introduce': _introduceTextEditingController.text,
      };

      // all music 에 artist 이름 변경
      String newArtistName = _nameTextEditingController.text;
      String userId = Provider.of<UserProfileProvider>(context, listen: false)
          .userProfileData
          .id;

      FirebaseDBHelper.updateAllMusicArtist(
          FirebaseDBHelper.allMusicCollection, newArtistName, userId);

      FirebaseDBHelper.updateMyMusicArtist(
          FirebaseDBHelper.myMusicCollection, newArtistName, userId);

      // user 에 이름 artist 변경
      String collection = FirebaseDBHelper.userCollection;
      String doc = Provider.of<UserProfileProvider>(context, listen: false)
          .userProfileData
          .id;

      FirebaseDBHelper.updateData(collection, doc, data).whenComplete(
        () {
          EasyLoading.dismiss();
          return UploadResultDialog.showUploadResultDialog(context, '파일 업로드 성공')
              .then((result) {
            setState(() {
              FirebaseDBHelper.getData(collection, doc).then((value) {
                Provider.of<UserProfileProvider>(context, listen: false)
                    .userProfileData = UserProfileData.fromMap(value.data());
                if (result == true) Navigator.pop(context);
              });
            });
          });
        },
      );
    } else {
      UploadResultDialog.showUploadResultDialog(context, '파일 업로드 실패')
          .then((result) {
        setState(() {
          if (result == true) Navigator.pop(context);
        });
      });
    }
  }
}
