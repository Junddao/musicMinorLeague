import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class MySelectButtonsWidget extends StatelessWidget {
  const MySelectButtonsWidget({
    Key key,
    Function selectAllMusicFunc,
  })  : _selectAllMusicFunc = selectAllMusicFunc,
        super(key: key);

  final Function _selectAllMusicFunc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            IconButton(
              icon: Icon(
                Icons.select_all,
                // size: 14,
              ),
              onPressed: () {
                _selectAllMusicFunc();
              },
            ),
            Text(
              '모두선택',
              style: MTextStyles.bold10PinkishGrey,
            ),
          ],
        ),
      ],
    );
  }
}
