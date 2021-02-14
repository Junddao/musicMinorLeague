import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';

class ImportantArtistWidget extends StatefulWidget {
  @override
  _ImportantArtistWidgetState createState() => _ImportantArtistWidgetState();
}

class _ImportantArtistWidgetState extends State<ImportantArtistWidget> {
  @override
  Widget build(BuildContext context) {
    String collection = FirebaseDBHelper.allMusicCollection;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 40, bottom: 12.0),
          child: Text('좋은 음악을 만드는 아티스트', style: MTextStyles.bold18Black),
        ),
        //get artist name in music data
        StreamBuilder(
          stream: FirebaseDBHelper.getDataStream(collection),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('error'),
              );
            } else if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var allMusicList =
                  FirebaseDBHelper.getMusicDatabase(snapshot.data);
              List<String> liArtist = new List<String>();
              allMusicList.forEach((element) {
                liArtist.add(element.artist);
              });

              liArtist = liArtist.toSet().toList();

              String userCollection = FirebaseDBHelper.userCollection;

              //get user data
              return StreamBuilder(
                  stream: FirebaseDBHelper.getDataStream(userCollection),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('error'),
                      );
                    } else if (snapshot.hasData == false) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<UserProfileData> liArtistInfo =
                          FirebaseDBHelper.getUserDatabase(snapshot.data);
                      liArtistInfo.removeWhere((element) {
                        return !liArtist.contains(element.userName);
                      });
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        // itemExtent: 300.0,
                        itemCount: liArtistInfo.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ClipOval(
                                            // borderRadius:
                                            //     BorderRadius.circular(4.0),
                                            child: ExtendedImage.network(
                                              liArtistInfo[index].photoUrl,
                                              cache: true,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            liArtistInfo[index].userName,
                                            style: MTextStyles.bold14Black,
                                          ),
                                        ],
                                      ),
                                      FlatButton(
                                        onPressed: null,
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: MColors.tomato,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  width: 1,
                                                  color: MColors.tomato)),
                                          child: Center(
                                              child: Text(
                                            '프로필',
                                            style: MTextStyles.bold12White,
                                          )),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    liArtistInfo[index].introduce,
                                    overflow: TextOverflow.ellipsis,
                                    style: MTextStyles.regular12Black,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  });
            }
          },
        )
      ],
    );
  }
}
