import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';

class FirebaseDBHelper {
  static final userCollection = 'user';
  static final myMusicCollection = 'myMusic';
  static final mySelectedMusicCollection = 'mySelectedMusic';
  static final myUpdatedMusicCollection = 'myUpdatedMusicCollection';
  static final allMusicCollection = 'allMusic';
  static final firestoreinstance = FirebaseFirestore.instance;

  static Future<void> setData(
      String collection, String doc, Map<String, Object> data) async {
    await firestoreinstance.collection(collection).doc(doc).set(data);
  }

  static Future<void> setSubCollection(String mainCollection, String mainDoc,
      String subCollection, String subDoc, Map<String, Object> data) async {
    await firestoreinstance
        .collection(mainCollection)
        .doc(mainDoc)
        .collection(subCollection)
        .doc(subDoc)
        .set(data);
  }

  static Future<void> updateFavoriteData(
      String collection, String doc, int data) async {
    await firestoreinstance.collection(collection).doc(doc).update({
      'favorite': data,
    });
  }

  static Future<void> updateData(
      String collection, String doc, Map<String, dynamic> data) async {
    await firestoreinstance.collection(collection).doc(doc).update({
      'userName': data['userName'],
      'photoUrl': data['photoUrl'],
      'youtubeUrl': data['youtubeUrl'],
      'introduce': data['introduce'],
    });
  }

  static Future<void> deleteDoc(String collection, String doc) async {
    return await firestoreinstance.collection(collection).doc(doc).delete();
  }

  static Future<void> deleteSubDoc(String mainCollection, String mainDoc,
      String subCollection, String subDoc) async {
    return await firestoreinstance
        .collection(mainCollection)
        .doc(mainDoc)
        .collection(subCollection)
        .doc(subDoc)
        .delete();
  }

  static Future<DocumentSnapshot> getData(String collection, String doc) async {
    return await firestoreinstance.collection(collection).doc(doc).get();
  }

  static Stream<QuerySnapshot> getDataStream(String collection) {
    return firestoreinstance
        .collection(collection)
        .orderBy('favorite', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getSubDataStream(
      String mainCollection, String mainDoc, String subCollection) {
    return firestoreinstance
        .collection(mainCollection)
        .doc(mainDoc)
        .collection(subCollection)
        .snapshots();
  }

  static List<MusicInfoData> getMusicDatabase(QuerySnapshot qs) {
    List<MusicInfoData> musicList = new List<MusicInfoData>();
    for (int idx = 0; idx < qs.docs.length; idx++) {
      MusicInfoData musicInfoData = new MusicInfoData();
      musicInfoData.id = qs.docs[idx].data()['id'];
      musicInfoData.artist = qs.docs[idx].data()['artist'];
      musicInfoData.dateTime = qs.docs[idx].data()['dateTime'];
      musicInfoData.favorite = qs.docs[idx].data()['favorite'];
      musicInfoData.imagePath = qs.docs[idx].data()['imagePath'];
      musicInfoData.musicPath = qs.docs[idx].data()['musicPath'];

      musicInfoData.musicType = EnumToString.fromString(
          MusicTypeEnum.values, qs.docs[idx].data()['musicType']);
      musicInfoData.title = qs.docs[idx].data()['title'];
      musicList.add(musicInfoData);

      int favoriteNum = qs.docs[idx].data()['favorite'];

      print(favoriteNum);
    }

    return musicList;
  }
}
