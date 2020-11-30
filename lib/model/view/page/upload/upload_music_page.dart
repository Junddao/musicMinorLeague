import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/upload/component/upload_result_Dialog.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'component/cancel_Dialog.dart';
import 'component/choice_chip_widget.dart';

import 'package:firebase_storage/firebase_storage.dart';

class UploadMusicPage extends StatefulWidget {
  @override
  _UploadMusicPageState createState() => _UploadMusicPageState();
}

class _UploadMusicPageState extends State<UploadMusicPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _titleController = new TextEditingController();

  String _coverImagePath;
  String _musicPath;

  File _coverImage, _musicFile;
  String imageFileUrl, musicFileUrl;

  String _artist;
  Reference ref;
  MusicTypeEnum _typeOfMusic;

  List<Asset> _coverImageList;

  bool isPlay = false;

  final firestoreinstance = FirebaseFirestore.instance;

  @override
  void initState() {
    _coverImageList = List<Asset>();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
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
                CancelDialog.showCancelDialog(context).then((value) {
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
              '음악 등록하기',
              style: MTextStyles.bold16Black2,
            ),
          ),
          FlatButton(
            onPressed: () async {
              // must attach image and music file.
              _coverImage != null && _musicFile != null ? await upload() : null;
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
    _artist = Provider.of<UserProfileProvider>(context).userProfileData.id;
    List<MusicTypeEnum> typeOfMusicList = List.generate(
        MusicTypeEnum.values.length, (index) => MusicTypeEnum.values[index]);
    return SingleChildScrollView(
      physics: new ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            musicTitle(),
            SizedBox(height: 30),
            musicType(typeOfMusicList),
            SizedBox(height: 30),
            selectMusicWidget(),
            SizedBox(height: 30),
            selectCoverImage(),
          ],
        ),
      ),
    );
  }

  getMusicFileContainer() {
    Widget musicContentsWidget;
    if (_musicPath == null) {
      musicContentsWidget = Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: MColors.white_three, width: 1),
            color: MColors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/library_music.svg'),
                SizedBox(
                  width: 6,
                ),
                Text('음악 등록하기', style: MTextStyles.medium12BrownishGrey),
              ],
            ),
          ),
        ),
      );
    } else {
      musicContentsWidget = RawMaterialButton(
        onPressed: () {},
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isPlay = !isPlay;
                    isPlay == true
                        ? PlayMusic.playFileFunc(_musicPath)
                        : PlayMusic.pauseFunc();
                  });
                },
                child: SvgPicture.asset(
                  isPlay == true
                      ? 'assets/icons/pause.svg'
                      : 'assets/icons/play.svg',
                  fit: BoxFit.cover,
                  color: MColors.tomato,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _musicPath = null;
                    });
                  },
                  child: _getSelectedPhotoEraseCircle()),
            )
          ],
        ),
      );
    }

    return musicContentsWidget;
  }

  getCoverImageContainer() {
    Widget imageContentsWidget;
    if (_coverImagePath == null) {
      imageContentsWidget = Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: MColors.white_three, width: 1),
            color: MColors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/add_photo_alternate.svg'),
                SizedBox(
                  width: 6,
                ),
                Text('사진 첨부하기', style: MTextStyles.medium12BrownishGrey),
              ],
            ),
          ),
        ),
      );
    } else {
      imageContentsWidget = RawMaterialButton(
        onPressed: () {},
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(_coverImagePath),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _coverImagePath = null;
                    });
                  },
                  child: _getSelectedPhotoEraseCircle()),
            )
          ],
        ),
      );
    }
    return imageContentsWidget;
  }

  Widget _getSelectedPhotoEraseCircle() {
    return Container(
      height: 24,
      width: 24,
      child: CircleAvatar(
        child: Icon(
          Icons.close,
          size: 16,
          color: Colors.white.withOpacity(0.8),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
    );
  }

  musicTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('노래 제목', style: MTextStyles.bold16Black),
            SizedBox(height: 40),
          ],
        ),
        Container(
          height: 54,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "노래 제목을 입력해주세요..",
              hintStyle: MTextStyles.medium16WhiteThree,
              labelStyle: TextStyle(color: Colors.transparent),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  musicType(typeOfMusicList) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('장르 선택', style: MTextStyles.bold16Black),
            SizedBox(height: 40),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: 5.0, // gap between adjacent chips
          runSpacing: 5.0, // gap between lines

          children: [
            ChoiceChipWidget(
              typeOfMusicList: typeOfMusicList,
              returnDataFunc: returnDataFunc,
            ),
          ],
        ),
      ],
    );
  }

  void returnDataFunc(MusicTypeEnum selectedData) {
    setState(() {
      _typeOfMusic = selectedData;
    });
  }

  selectMusicWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('음악 파일 선택', style: MTextStyles.bold16Black),
            SizedBox(height: 40),
          ],
        ),
        Container(
          height: 180,
          width: SizeConfig.screenWidth - 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          //width: SizeConfig.screenWidth - 40,
          child: Center(
            child: InkWell(
              onTap: () async {
                await getMusic();
              },
              child: getMusicFileContainer(),
            ),
          ),
        ),
      ],
    );
  }

  selectCoverImage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('커버 사진 선택', style: MTextStyles.bold16Black),
            SizedBox(height: 40),
          ],
        ),
        Container(
          height: 180,
          width: SizeConfig.screenWidth - 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          //width: SizeConfig.screenWidth - 40,
          child: Center(
            child: InkWell(
              onTap: () async {
                await getImage();
              },
              child: getCoverImageContainer(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getImage() async {
    String error = 'No Error Dectected';
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: _coverImageList,
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: "#e73331",
          selectionTextColor: "#ffffff",
        ),
        // andorid 용 UI 변경해야함
        materialOptions: MaterialOptions(
          actionBarTitle: "사진 선택",
          allViewTitle: "전체 사진",
          actionBarColor: "#e73331",
          actionBarTitleColor: "#ffffff",
          lightStatusBar: true,
          statusBarColor: '#e73331',
          startInAllView: false,
          selectCircleStrokeColor: "#ffffff",
          selectionLimitReachedText: "사진은 1장만 선택가능 합니다.",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    _coverImageList = resultList;
    for (Asset asset in _coverImageList) {
      _coverImagePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      _coverImage = File(_coverImagePath);
    }
    setState(() {});
  }

  Future<void> getMusic() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _musicPath = result.files.single.path;
      _musicFile = File(_musicPath);
    } else {
      // User canceled the picker
      _musicPath = null;
      _musicFile = null;
    }
    setState(() {});
  }

  Future<void> upload() async {
    await uploadImageFile(_coverImage);
    await uploadMusicFile(_musicFile);
  }

  Future<String> uploadImageFile(File imageFile) async {
    var now = DateTime.now();
    String filename = _titleController.text + '_image';
    String date =
        now.year.toString() + now.month.toString() + now.day.toString();
    ref = FirebaseStorage.instance
        .ref()
        .child(date)
        .child(_artist)
        .child(filename);

    UploadTask uploadTask = ref.putFile(imageFile);

    String url;
    await uploadTask.then((TaskSnapshot snapshot) {
      snapshot.ref.getDownloadURL().then((fileUrl) {
        imageFileUrl = fileUrl;
        if (musicFileUrl != null) updateDatabase();
      });
    });
    return url;
  }

  Future<void> uploadMusicFile(File _musicFile) async {
    var now = DateTime.now();
    String filename = _titleController.text + '_music';
    String date =
        now.year.toString() + now.month.toString() + now.day.toString();
    ref = FirebaseStorage.instance
        .ref()
        .child(date)
        .child(_artist)
        .child(filename);

    UploadTask uploadTask = ref.putFile(_musicFile);

    await uploadTask.then((TaskSnapshot snapshot) {
      snapshot.ref.getDownloadURL().then((fileUrl) {
        musicFileUrl = fileUrl;
        if (imageFileUrl != null) updateDatabase();
      });
    });
  }

  updateDatabase() {
    if (_titleController.text != null &&
        musicFileUrl != null &&
        imageFileUrl != null) {
      var data = {
        "id": Uuid().v4(),
        "title": _titleController.text,
        "artist": _artist,
        "musicType": EnumToString.convertToString(_typeOfMusic),
        "musicPath": musicFileUrl,
        "imagePath": imageFileUrl,
        "dateTime": DateTime.now().toIso8601String(),
        "favorite": 0,
      };

      firestoreinstance
          .collection('allMusic')
          .doc(DateTime.now().toIso8601String())
          .set(data)
          .whenComplete(
            () =>
                UploadResultDialog.showUploadResultDialog(context, '파일 업로드 성공')
                    .then((value) {
              setState(() {
                if (value == true) Navigator.pop(context);
              });
            }),
            // showDialog(
            //   context: context,
            //   builder: (context) =>
            //       _onTapButton(context, "Files Uploaded Successfully :)"),
            // ),
          );
    } else {
      UploadResultDialog.showUploadResultDialog(context, '파일 업로드 실패')
          .then((value) {
        setState(() {
          if (value == true) Navigator.pop(context);
        });
      });
      // showDialog(
      //   context: context,
      //   builder: (context) =>
      //       _onTapButton(context, "Please Enter All Details :("),
      // );
    }
  }

  // _onTapButton(BuildContext context, data) {
  //   return AlertDialog(title: Text(data));
  //   //  Navigator.of(context).pop();  // 여기에 ok 버튼 누러서 pop 추가해야함

  // }
}
