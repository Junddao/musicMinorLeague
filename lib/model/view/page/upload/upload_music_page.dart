import 'dart:async';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:music_minorleague/model/data/send_file.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/upload/component/upload_result_dialog.dart';

import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'component/cancel_Dialog.dart';
import 'component/choice_chip_widget.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_minorleague/model/api_service/api_service_provider.dart';

class UploadMusicPage extends StatefulWidget {
  @override
  _UploadMusicPageState createState() => _UploadMusicPageState();
}

class _UploadMusicPageState extends State<UploadMusicPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _titleController = new TextEditingController();

  final picker = ImagePicker();

  String _coverImagePath;
  String _musicPath;

  File _coverImage, _musicFile;
  String imageFileUrl, musicFileUrl;

  String _artist;
  String _userId;
  Reference ref;
  MusicTypeEnum _typeOfMusic;

  bool isPlay = false;
  Timer _timer;

  String uniqueId;

  final firestoreinstance = FirebaseFirestore.instance;

  @override
  void initState() {
    uniqueId = Uuid().v4();
    _typeOfMusic = MusicTypeEnum.etc;
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
              if (isPlay == true) PlayMusic.pauseFunc();
              if (_coverImage != null && _musicFile != null) await upload();
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
    _artist =
        Provider.of<UserProfileProvider>(context).userProfileData.userName;
    _userId = Provider.of<UserProfileProvider>(context).userProfileData.id;
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
              onTap: () {
                getMusic();
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
              onTap: () {
                getImage();
              },
              child: getCoverImageContainer(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _coverImagePath = pickedFile.path;
        _coverImage = File(_coverImagePath);
      } else {
        print('No image selected.');
      }
    });
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
    await EasyLoading.show(
      status: 'uploading...',
      maskType: EasyLoadingMaskType.black,
    );

    await uploadImageFile();
    await uploadMusicFile();
  }

  //bunny cdn 작업중

  // Future<void> uploadImageFile(File imageFile) async {
  //   String fileExtension = _coverImagePath.split('.').last;
  //   String filename =
  //       _titleController.text + uniqueId + '_image.' + fileExtension;

  //   SendFile sendFile = new SendFile(
  //     filePath: _coverImagePath,
  //   );
  //   ApiServiceProvider apiserviceProvider = new ApiServiceProvider();
  //   await apiserviceProvider
  //       .bunnyCdnUploadFile(sendFile, _artist, filename)
  //       .then((value) {
  //     if (value == true) {
  //       imageFileUrl = 'https://junddao.b-cdn.net/' + _artist + '/' + filename;
  //       // if (musicFileUrl != null) updateDatabase();
  //     }
  //   });
  // }

  // Future<void> uploadMusicFile(File _musicFile) async {
  //   var now = DateTime.now();
  //   String fileExtension = _musicPath.split('.').last;
  //   String filename =
  //       _titleController.text + uniqueId + '_music.' + fileExtension;
  //   ApiServiceProvider apiserviceProvider = new ApiServiceProvider();
  //   SendFile sendFile = new SendFile(
  //     filePath: _musicPath,
  //   );

  //   //bunnyCdn file upload, firebase database
  //   await apiserviceProvider
  //       .bunnyCdnUploadFile(sendFile, _artist, filename)
  //       .then((value) {
  //     if (value == true) {
  //       musicFileUrl = 'https://junddao.b-cdn.net/' + _artist + '/' + filename;
  //       // if (imageFileUrl != null) updateDatabase();
  //     }
  //   });

  // ref = FirebaseStorage.instance.ref().child(_artist).child(filename);

  // UploadTask uploadTask = ref.putFile(_musicFile);

  // await uploadTask.then((TaskSnapshot snapshot) {
  //   snapshot.ref.getDownloadURL().then((fileUrl) {
  //     musicFileUrl = fileUrl;
  //     if (imageFileUrl != null) updateDatabase();
  //   });
  // });
  // }

  Future<void> uploadMusicFile() async {
    String formattedDate = DateFormat('yyyyMMddhhmmss').format(DateTime.now());
    String filename = _titleController.text + '_' + formattedDate + '_music';

    ref = FirebaseStorage.instance.ref().child(_userId).child(filename);

    UploadTask uploadTask = ref.putFile(_musicFile);

    await uploadTask.then((TaskSnapshot snapshot) {
      snapshot.ref.getDownloadURL().then((fileUrl) {
        musicFileUrl = fileUrl;
        if (imageFileUrl != null) updateDatabase();
      });
    });
  }

  Future<void> uploadImageFile() async {
    String formattedDate = DateFormat('yyyyMMddhhmmss').format(DateTime.now());
    String filename = _titleController.text + '_' + formattedDate + '_image';

    ref = FirebaseStorage.instance.ref().child(_userId).child(filename);

    UploadTask uploadTask = ref.putFile(_coverImage);

    await uploadTask.then((TaskSnapshot snapshot) {
      snapshot.ref.getDownloadURL().then((fileUrl) {
        imageFileUrl = fileUrl;

        if (musicFileUrl != null) updateDatabase();
      });
    });
  }

  updateDatabase() {
    if (_titleController.text != null &&
        musicFileUrl != null &&
        imageFileUrl != null) {
      var data = {
        "id": uniqueId,
        "userId": _userId,
        "title": _titleController.text,
        "artist": _artist,
        "musicType": EnumToString.convertToString(_typeOfMusic),
        "musicPath": musicFileUrl,
        "imagePath": imageFileUrl,
        "dateTime": DateTime.now().toIso8601String(),
        "favorite": 0,
      };

      String collection = 'allMusic';
      String doc = data['id'];

      FirebaseDBHelper.setData(collection, doc, data).whenComplete(
        () {
          EasyLoading.dismiss();
          return UploadResultDialog.showUploadResultDialog(context, '파일 업로드 성공')
              .then((value) {
            setState(() {
              if (value == true) Navigator.pop(context);
            });
          });
        },
      );
    } else {
      UploadResultDialog.showUploadResultDialog(context, '파일 업로드 실패')
          .then((value) {
        setState(() {
          if (value == true) Navigator.pop(context);
        });
      });
    }
  }
}
