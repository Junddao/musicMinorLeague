import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

import 'component/cancel_Dialog.dart';

class UploadMusicPage extends StatefulWidget {
  @override
  _UploadMusicPageState createState() => _UploadMusicPageState();
}

class _UploadMusicPageState extends State<UploadMusicPage> {
  TextEditingController _titleController = new TextEditingController();

  String _coverFile;

  @override
  void dispose() {
    _titleController.dispose();
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
            onPressed: () async {},
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
    List<MusicTypeEnum> typeOfMusicList = List.generate(
        MusicTypeEnum.etc.index, (index) => MusicTypeEnum.values[index]);
    return SingleChildScrollView(
      physics: new ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
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
            SizedBox(height: 30),
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
                // for (MusicTypeEnum value in typeOfMusicList)
                choiceChips(typeOfMusicList),
              ],
            ),
            SizedBox(height: 30),
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
                  onTap: () async {},
                  child: getMusicFileContainer(),
                ),
              ),
            ),
            SizedBox(height: 30),
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
                  onTap: () async {},
                  child: getCoverImageContainer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget choiceChips(List<MusicTypeEnum> chipList) {
    return Expanded(
      child: ListView.builder(
        itemCount: chipList.length,
        itemBuilder: (BuildContext context, int index) {
          return ChoiceChip(
            label: Text(getLabelTypeOfMusicList(chipList[index])),
            selected: _defaultChoiceIndex == index,
            selectedColor: Colors.green,
            onSelected: (bool selected) {
              setState(() {
                _defaultChoiceIndex = selected ? index : 0;
              });
            },
            backgroundColor: Colors.blue,
            labelStyle: TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }

  getMusicFileContainer() {
    return Container(
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
  }

  getCoverImageContainer() {
    Widget contentsWidget;
    if (_coverFile == null) {
      contentsWidget = Container(
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
      contentsWidget = RawMaterialButton(
        onPressed: () {
          setState(() {
            _coverFile = null;
          });
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(_coverFile),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: _getSelectedPhotoEraseCircle(),
            )
          ],
        ),
      );
    }
    return contentsWidget;
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

  String getLabelTypeOfMusicList(MusicTypeEnum value) {
    String returnString;
    switch (value) {
      case MusicTypeEnum.classical:
        returnString = '클래식';
        break;
      case MusicTypeEnum.contry:
        returnString = '컨트리';
        break;
      case MusicTypeEnum.dance:
        returnString = '댄스';
        break;
      case MusicTypeEnum.electronic:
        returnString = '일렉트로닉';
        break;

      case MusicTypeEnum.folk:
        returnString = '포크';
        break;
      case MusicTypeEnum.hiphop:
        returnString = '힙합';
        break;
      case MusicTypeEnum.jazz:
        returnString = '재즈';
        break;
      case MusicTypeEnum.pop:
        returnString = '팝';
        break;
      case MusicTypeEnum.rap:
        returnString = '랩';
        break;
      case MusicTypeEnum.rock:
        returnString = '락';
        break;
      case MusicTypeEnum.etc:
        returnString = '기타';
        break;
    }
    return returnString;
  }
}
