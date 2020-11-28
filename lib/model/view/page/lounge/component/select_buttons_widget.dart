import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class SelectButtonsWidget extends StatelessWidget {
  const SelectButtonsWidget({
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
              icon: Icon(Icons.check),
              onPressed: () {
                _selectAllMusicFunc();
              },
            ),
            Text(
              '전체',
              style: MTextStyles.bold12PinkishGrey,
            ),
          ],
        ),
      ],
    );
  }
}
