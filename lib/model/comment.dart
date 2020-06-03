import 'dart:io';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  Future<String> CreateComment({
    String storyid,
    String userid,
    String comment,
  }) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    Firestore.instance
        .collection("user")
        .document(firebaseUser.uid)
        .get()
        .then((value) async {
      print(value.data);
      await Firestore.instance
          .collection('story')
          .document(storyid)
          .collection("comment")
          .add({"userid": userid, "comment": comment, "create_at": formatted, "time": now});
    });
  }
}
