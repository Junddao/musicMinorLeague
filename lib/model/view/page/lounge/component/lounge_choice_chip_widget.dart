import 'package:flutter/material.dart';
import 'package:music_minorleague/model/enum/lounge_music_type_enum.dart';

import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class LoungeChoiceChipWidget extends StatefulWidget {
  const LoungeChoiceChipWidget({
    Key key,
    List<LoungeMusicTypeEnum> typeOfMusicList,
    Function returnDataFunc,
  })  : _typeOfMusicList = typeOfMusicList,
        _returnDataFunc = returnDataFunc,
        super(key: key);
  final List<LoungeMusicTypeEnum> _typeOfMusicList;
  final Function _returnDataFunc;

  @override
  _LoungeChoiceChipWidgetState createState() =>
      new _LoungeChoiceChipWidgetState();
}

class _LoungeChoiceChipWidgetState extends State<LoungeChoiceChipWidget> {
  LoungeMusicTypeEnum selectedChoice;

  _buildChoiceList() {
    List<Widget> choices = List();
    widget._typeOfMusicList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(getLabelTypeOfMusicList(item)),
          labelStyle: selectedChoice != item
              ? MTextStyles.bold14Black
              : MTextStyles.bold14White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: MColors.tomato,
          selected: selectedChoice == item,
          onSelected: (selected) {
            widget._returnDataFunc(item);
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  void initState() {
    selectedChoice = LoungeMusicTypeEnum.all;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }

  String getLabelTypeOfMusicList(LoungeMusicTypeEnum value) {
    String returnString;
    switch (value) {
      case LoungeMusicTypeEnum.all:
        returnString = '전체';
        break;
      case LoungeMusicTypeEnum.classical:
        returnString = '차분함';
        break;
      case LoungeMusicTypeEnum.contry:
        returnString = '낭만적';
        break;
      case LoungeMusicTypeEnum.dance:
        returnString = '밝음';
        break;
      case LoungeMusicTypeEnum.electronic:
        returnString = '신남';
        break;
      case LoungeMusicTypeEnum.folk:
        returnString = '감성적';
        break;
      case LoungeMusicTypeEnum.hiphop:
        returnString = '힙합';
        break;
      case LoungeMusicTypeEnum.pop:
        returnString = '팝';
        break;
      case LoungeMusicTypeEnum.rap:
        returnString = '랩';
        break;
      case LoungeMusicTypeEnum.rock:
        returnString = '락';
        break;
      case LoungeMusicTypeEnum.trot:
        returnString = '트로트';
        break;

      case LoungeMusicTypeEnum.etc:
        returnString = '기타';
        break;
    }
    return returnString;
  }
}
