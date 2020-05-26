import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:failure/main.dart';
import 'package:failure/page/root_page.dart';
import 'package:failure/page/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.logoutCallback});

  final VoidCallback logoutCallback;
  BaseAuth auth;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid;
  @override
  void user() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      setState(() {
        uid = firebaseUser.uid;
      });
    }
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      widget.logoutCallback();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    user();
    return new StreamBuilder(
        stream: Firestore.instance.collection('user').document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new CircularProgressIndicator();
          }
          var userDocument = snapshot.data;
          print(userDocument);
          return new RaisedButton(
              child: Text(userDocument["anonym"]),
              onPressed: () {
                signOut().then((onValue) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }));
                });
              });
        });
  }
}
