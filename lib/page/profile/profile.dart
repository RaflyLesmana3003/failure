import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:failure/main.dart';
import 'package:failure/model/user.dart';
import 'package:failure/page/root_page.dart';
import 'package:failure/page/services/authentication.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.logoutCallback});

  final VoidCallback logoutCallback;
  BaseAuth auth;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid;
  File imagefile;
  String anonym;
int click = 1;
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
      await GoogleSignIn().signOut();
      widget.logoutCallback();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagefile = picture;
      print(imagefile);
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imagefile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showchoicedialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("select image"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("galery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
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
          // print(userDocument);
          // return new RaisedButton(
          //     child: Text(userDocument["anonym"]),
          //     onPressed: () {
          //       signOut().then((onValue) {
          //         Navigator.push(context, MaterialPageRoute(builder: (context) {
          //           return MyApp();
          //         }));
          //       });
          //     });
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                title: Text("Profile"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.input, color: Colors.white),
                      onPressed: () => signOut().then((onValue) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MyApp();
                            }));
                          }))
                ],
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        // hex decimal
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        colors: [
                          Colors.pinkAccent[400],
                          Colors.deepOrangeAccent
                        ]),
                  ),
                ),
              ),
            ),
            floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: (click == 1)
                ?FloatingActionButton.extended(
                  label: Text("Save"),
                  backgroundColor: Colors.pinkAccent[400],
                  icon: Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                        click = 0;
                      });
                    if (anonym == null) {
                      anonym = userDocument["anonym"];
                    }
                    if (imagefile == null) {
                       UserModel().Userupdate(anonymname: anonym,image: userDocument["photo"]).then((onValue){
                      setState(() {
                        click = 1;
                      });
                    });
                    return false;
                    }
                    UserModel().Userupdate(anonymname: anonym,photo: imagefile,image: userDocument["photo"]).then((onValue){
                      setState(() {
                        click = 1;
                      });
                    });
                  },
                ):FloatingActionButton(
                  onPressed: (){},
                  backgroundColor: Colors.pinkAccent[400],
                  child: CircularProgressIndicator(backgroundColor: Colors.white,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent[700])),
                )),
            body: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xffFDCF09),
                            child: Stack(
                              children: <Widget>[
                                (userDocument["photo"] == null)
                                    ? (imagefile == null)
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.blue[800],
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.red,
                                            backgroundImage:
                                                FileImage(imagefile),
                                          )
                                    : (imagefile == null)
                                        ? CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                userDocument["photo"]),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.red,
                                            backgroundImage:
                                                FileImage(imagefile),
                                          ),
                                Positioned(
                                  bottom: 10,
                                  right: 1,
                                  left: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showchoicedialog(context);
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.pink,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: (anonym == null)
                                          ? Text(
                                              (anonym == null)
                                                  ? userDocument["anonym"]
                                                  : anonym,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          : Text(
                                              anonym,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                  GestureDetector(
                                    onTap: () {
                                      print(anonym);
                                      setState(() {
                                        String fake = faker.person.firstName() +
                                            faker.person.lastName() +
                                            faker.randomGenerator
                                                .decimal(scale: 999)
                                                .toInt()
                                                .toString();
                                        anonym = fake;
                                        print(anonym);
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.pink,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Container(
                                // margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  userDocument["name"],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  userDocument["email"],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
