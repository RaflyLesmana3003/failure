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
  String email;
  String name;
   user() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      
    });
      email = firebaseUser.email;
      name = firebaseUser.displayName;
  }

  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
        widget.logoutCallback();
        
      
    } catch (e) {
      print(e);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    user();
    return (name == null)
        ? CircularProgressIndicator(
            backgroundColor: Colors.red,
          )
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(name),
                RaisedButton(child: Text("data"), onPressed: () => signOut())
              ],
            ),
          );
  }
}
