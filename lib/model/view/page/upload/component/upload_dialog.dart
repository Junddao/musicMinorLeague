import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class UploadDialog {
  static Future<bool> showUploadDialog(BuildContext context) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '잠시만요',
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontFamily: "AppleSDGothicNeo",
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0),
                ),
                SizedBox(height: 10),
                Text(
                  '등록하시는 음악은 별도 보상없이\n무료로 모든 사용자에게 들려질 꺼에요.\n등록할까요?',
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansCJKkr",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                ),
                SizedBox(height: 20),
                Divider(height: 0),
                Container(
                  height: 43.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('취소하기'),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            // Navigator.pop(context, true);
                          },
                          child: Text(
                            '등록하기',
                            style: MTextStyles.bold16Tomato,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result;
  }
}
