import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/view/page/upload/component/upload_result_Dialog.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class SmallSelectListWidget extends StatefulWidget {
  const SmallSelectListWidget({
    Key key,
    List<MusicInfoData> musicList,
    List<bool> selectedList,
  })  : _musicList = musicList,
        _selectedList = selectedList,
        super(key: key);

  final List<MusicInfoData> _musicList;
  final List<bool> _selectedList;

  @override
  _SmallSelectListWidgetState createState() => _SmallSelectListWidgetState();
}

class _SmallSelectListWidgetState extends State<SmallSelectListWidget> {
  List<MusicInfoData> selectedMusicList = new List<MusicInfoData>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 80,
              width: SizeConfig.screenWidth - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                border: Border.all(color: Colors.black12, width: 1),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            getSelectedMusicList();
                            // updateMyMusicList();
                          }),
                      Text(
                        '내 재생 목록 추가',
                        style: MTextStyles.bold12PinkishGrey,
                      ),
                    ],
                  ),
                  VerticalDivider(
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Column(
                    children: [
                      IconButton(
                          iconSize: 14,
                          icon: Icon(FontAwesomeIcons.play),
                          onPressed: null),
                      Text(
                        '선택 항목 재생',
                        style: MTextStyles.bold12PinkishGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: widget._musicList == null
                ? SizedBox.shrink()
                : CircleAvatar(
                    radius: 15,
                    backgroundColor: MColors.tomato,
                    child: Text(
                      widget._selectedList
                          .where((element) => element == true)
                          .length
                          .toString(),
                      style: MTextStyles.bold14White,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void getSelectedMusicList() {
    selectedMusicList.clear();
    for (int i = 0; i < widget._selectedList.length; i++) {
      if (widget._selectedList[i] == true) {
        selectedMusicList.add(widget._musicList[i]);
      }
    }
  }

  // updateMyMusicList() {
  //   if (selectedMusicList != null)
  //   {
  //     if(selectedMusicList.length > 0){

  //     // var data = {
  //     //   "title": _titleController.text,
  //     //   "artist": _artist,
  //     //   "musicType": EnumToString.convertToString(_typeOfMusic),
  //     //   "musicPath": musicFileUrl,
  //     //   "imagePath": imageFileUrl,
  //     //   "dateTime": DateTime.now().toIso8601String(),
  //     //   "favorite": 0,
  //     // };

  //     FirebaseFirestore.instance
  //         .collection('allMusic')
  //         .doc(DateTime.now().toIso8601String())
  //         .set(data)
  //         .whenComplete(
  //           () =>
  //               UploadResultDialog.showUploadResultDialog(context, '파일 업로드 성공')
  //                   .then((value) {
  //             setState(() {
  //               if (value == true) Navigator.pop(context);
  //             });
  //           }),
  //           // showDialog(
  //           //   context: context,
  //           //   builder: (context) =>
  //           //       _onTapButton(context, "Files Uploaded Successfully :)"),
  //           // ),
  //         );
  //   } else {
  //     UploadResultDialog.showUploadResultDialog(context, '파일 업로드 실패')
  //         .then((value) {
  //       setState(() {
  //         if (value == true) Navigator.pop(context);
  //       });
  //     });
  //     // showDialog(
  //     //   context: context,
  //     //   builder: (context) =>
  //     //       _onTapButton(context, "Please Enter All Details :("),
  //     // );

  // }
}
