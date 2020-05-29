import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  void initState() {
    super.initState();
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
                                children: <Widget>[
                                  ZefyrView(
                                      document: NotusDocument.fromJson(
                                          jsonDecode(storydoc["story"]))),
                                  SizedBox(
                                    width: double.infinity,
                                                                      child: OutlineButton(
                                      borderSide: BorderSide(color: Colors.pinkAccent[100]),
                                      color: Colors.pinkAccent[400],
                                        child: Text("Insight"),
                                        onPressed: () {
                                          print("object");
                                        }),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
