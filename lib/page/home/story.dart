

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Story extends StatefulWidget {
  @override
  _StoryScrollState createState() => new _StoryScrollState();
}

class _StoryScrollState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("story")
                .orderBy("created_at", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return const Center(
                    child: CircularProgressIndicator());
              return ListView(children: GetDatasstory(snapshot));
            }));
  }
   GetDatasstory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new  Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xffFDCF09),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            "https://cdn.pixabay.com/photo/2018/01/20/08/33/sunset-3094078_960_720.jpg"),
                                      ),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "anonym/darkslayer123",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              doc["created_at"],
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              (doc['image'] != null)?Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                           doc['image'] ),
                                        fit: BoxFit.cover)),
                              ):Container(
                                margin: EdgeInsets.only(top: 10),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                  child: Text(
                                    doc["title"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
                                  )),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.favorite_border,size: 15,),
                                        Text(" 1000")
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.chat_bubble_outline,size: 15,),
                                        Text(" 1000")
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )))
        .toList();
  }
}

class YourStoryData extends StatefulWidget {
  @override
  _YourStoryDataState createState() => new _YourStoryDataState();
}

class _YourStoryDataState extends State<YourStoryData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("story")
                .orderBy("created_at", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return const Center(
                    child: CircularProgressIndicator());
              return ListView(children: GetDatasstory(snapshot));
            }));
  }
   GetDatasstory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new  Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xffFDCF09),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            "https://cdn.pixabay.com/photo/2018/01/20/08/33/sunset-3094078_960_720.jpg"),
                                      ),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "anonym/darkslayer123",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              doc["created_at"],
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              (doc['image'] != null)?Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                           doc['image'] ),
                                        fit: BoxFit.cover)),
                              ):Container(
                                margin: EdgeInsets.only(top: 10),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                  child: Text(
                                    doc["title"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
                                  )),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.favorite_border,size: 15,),
                                        Text(" 1000")
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.chat_bubble_outline,size: 15,),
                                        Text(" 1000")
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )))
        .toList();
  }
}