import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:failure/model/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class ViewStory extends StatefulWidget {
  ViewStory(this.docid);
  String docid;
  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController comment;
  String _comment;

  @override
  void initState() {
    super.initState();
    comment = new TextEditingController();

    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Text("Story"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    // hex decimal
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    colors: [Colors.pinkAccent[400], Colors.deepOrangeAccent]),
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(),
          child: FloatingActionButton.extended(
              label: Text("Comment"),
              icon: Icon(Icons.add),
              backgroundColor: Colors.pinkAccent[400],
              onPressed: () async{
                if (_comment != null) {
                  print(_comment);

                  var firebaseUser = await FirebaseAuth.instance.currentUser();
                  CommentModel()
                      .CreateComment(
                          userid: firebaseUser.uid,
                          comment: comment.text.toString(),
                          storyid: widget.docid)
                      .then((value) {
                    setState(() {
                      comment.text = "";
                    });
                  });
                }
              }),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("story")
                .document(widget.docid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              var storydoc = snapshot.data;

              return ListView(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('user')
                                        .document(storydoc["useruid"])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      var userDocument = snapshot.data;
                                      return CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Color(0xffFDCF09),
                                          child: (userDocument["photo"] != null)
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                      userDocument["photo"]),
                                                )
                                              : CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor:
                                                      Colors.blue[800],
                                                ));
                                    }),
                                Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('user')
                                                .document(storydoc["useruid"])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              }
                                              var userDocument = snapshot.data;
                                              return Row(
                                                children: <Widget>[
                                                  Text("anonym/"),
                                                  Text(
                                                    userDocument["anonym"],
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              );
                                            }),
                                        // Text(
                                        //   name(do),
                                        //   style: TextStyle(
                                        //       fontSize: 17,
                                        //       fontWeight: FontWeight.w600),
                                        // ),
                                        Text(
                                          storydoc["created_at"],
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Text(
                            storydoc["title"],
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              storydoc["created_at"],
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          (storydoc['image'] != null)
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(storydoc['image']),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 10),
                                ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Story",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  ZefyrView(
                                      document: NotusDocument.fromJson(
                                          jsonDecode(storydoc["story"]))),
                                  (storydoc["insight"]
                                              .toString()
                                              .length
                                              .toInt() <
                                          17)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Divider(
                                              thickness: 2,
                                            ),
                                            Text(
                                              "Insight",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            ZefyrView(
                                                document: NotusDocument
                                                    .fromJson(jsonDecode(
                                                        storydoc["insight"])))
                                          ],
                                        )
                                      : Center()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        ////////

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Comment:',
                              labelText: 'Comment:',
                            ),
                            autofocus: false,
                            maxLines: null,
                            controller: comment,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                _comment = value;
                              });
                            },
                          ),
                          Divider(),
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection("story")
                                  .document(widget.docid.toString())
                                  .collection("comment")
                                  .orderBy("time", descending: true)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData)
                                  return const Center(
                                      child: CircularProgressIndicator());
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: GetDatasstory(snapshot));
                              }),

                          ////////
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }

  GetDatasstory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: <Widget>[
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection('user')
                                .document(doc["userid"])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              var userDocument = snapshot.data;
                              return CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Color(0xffFDCF09),
                                  child: (userDocument["photo"] != null)
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              userDocument["photo"]),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.blue[800],
                                        ));
                            }),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('user')
                                        .document(doc["userid"])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      var userDocument = snapshot.data;
                                      return Row(
                                        children: <Widget>[
                                          Text(
                                            userDocument["name"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      );
                                    }),
                                Text(
                                  doc["create_at"],
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      doc["comment"],
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider()
                ],
              ),
            ))
        .toList();
  }
}
