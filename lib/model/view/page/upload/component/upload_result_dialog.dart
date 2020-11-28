import 'package:flutter/material.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

class UploadResultDialog {
  static Future<bool> showUploadResultDialog(
      BuildContext context, String msg) async {
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
                  msg,
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontFamily: "AppleSDGothicNeo",
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0),
                ),
                SizedBox(height: 2),
                // Text(
                //   '음악 등록을 취소하시겠습니까?',
                //   style: TextStyle(
                //       color: const Color(0xff000000),
                //       fontWeight: FontWeight.w400,
                //       fontFamily: "NotoSansCJKkr",
                //       fontStyle: FontStyle.normal,
                //       fontSize: 13.0),
                // ),
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
                            Navigator.pop(context, true);
                          },
                          child: Text('확인'),
                        ),
                      ),
                      // VerticalDivider(),
                      // Expanded(
                      //   child: FlatButton(
                      //     onPressed: () {
                      //       Navigator.pop(context, true);
                      //       // Navigator.pop(context, true);
                      //     },
                      //     child: Text(
                      //       '등록취소',
                      //       style: MTextStyles.bold16Tomato,
                      //     ),
                      //   ),
                      // ),
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
