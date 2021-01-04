import 'package:flutter/material.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class ChoiceChipWidget extends StatefulWidget {
  const ChoiceChipWidget({
    Key key,
    List<MusicTypeEnum> typeOfMusicList,
    Function returnDataFunc,
  })  : _typeOfMusicList = typeOfMusicList,
        _returnDataFunc = returnDataFunc,
        super(key: key);
  final List<MusicTypeEnum> _typeOfMusicList;
  final Function _returnDataFunc;

  @override
  _ChoiceChipWidgetState createState() => new _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  MusicTypeEnum selectedChoice;

  _buildChoiceList() {
    List<Widget> choices = List();
    widget._typeOfMusicList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(getLabelTypeOfMusicList(item)),
          labelStyle: MTextStyles.bold14Black,
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
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }

  String getLabelTypeOfMusicList(MusicTypeEnum value) {
    String returnString;
    switch (value) {
      case MusicTypeEnum.classical:
        returnString = '차분함';
        break;
      case MusicTypeEnum.contry:
        returnString = '낭만적';
        break;
      case MusicTypeEnum.dance:
        returnString = '밝음';
        break;
      case MusicTypeEnum.electronic:
        returnString = '신나는';
        break;
      case MusicTypeEnum.folk:
        returnString = '영감적인';
        break;
      case MusicTypeEnum.hiphop:
        returnString = '힙합';
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
