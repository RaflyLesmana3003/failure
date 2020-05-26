import 'dart:convert';
import 'dart:io';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zefyr/zefyr.dart';

class UserModel {
  Future<String> Usercreate(
      {String name,
      int anonymname,
      int isanonym,
      String email,
      File photo}) async {
    String imageurl;
    var faker = new Faker();

    if (photo != null) {
      String imageName = basename(photo.path);
      StorageReference ref = FirebaseStorage.instance.ref().child(imageName);
      StorageUploadTask task = ref.putFile(photo);
      StorageTaskSnapshot snapshot = await task.onComplete;
      imageurl = await snapshot.ref.getDownloadURL();
    }
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
      if (value.data == null) {
        await Firestore.instance
            .collection('user')
            .document(firebaseUser.uid)
            .setData({
          'name': (name != null) ? name : null,
          'email': (email != null) ? email : null,
          'anonym': (anonymname != null)
              ? faker.person.firstName() +
                  faker.person.lastName() +
                  faker.randomGenerator.decimal(scale: 999).toInt().toString()
              : null,
          'isanonym': (isanonym == null) ? 1 : 0,
          'photo': (imageurl != null) ? imageurl : null,
        });
      }
    });
  }
}
