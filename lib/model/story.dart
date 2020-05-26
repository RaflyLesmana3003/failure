import 'dart:convert';
import 'dart:io';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zefyr/zefyr.dart';

class StoryModel {
  Future<String> createdraftStory(
      {String title,
      File image,
      NotusDocument story,
      NotusDocument insight}) async {
    String imageurl;
    if (image != null) {
      String imageName = basename(image.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(imageName);
      StorageUploadTask task = ref.putFile(image);
      StorageTaskSnapshot snapshot = await task.onComplete;
      imageurl = await snapshot.ref.getDownloadURL();
    }
    final storyjson = jsonEncode(story);
    final insightjson = jsonEncode(insight);
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
   String formatted = formatter.format(now);
    final docRef = await Firestore.instance
        .collection('story')
        .add({
      'useruid': firebaseUser.uid.toString(),
      'title': (title != null) ? title : null,
      'image': (imageurl != null) ? imageurl : null,
      'story': (storyjson != null) ? storyjson : null,
      'insight': (insightjson != null) ? insightjson : null,
      'ispublish': true,
      'created_at': formatted
    });

    return docRef.documentID.toString();
  }
}
