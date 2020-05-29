import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:failure/page/home/story.dart';
import 'package:failure/page/story/viewstory.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.pinkAccent[400]),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Text("Home"),
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
        body: Scaffold(
            body: StreamBuilder(
                stream: Firestore.instance
                    .collection("story")
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  return ListView(children: GetDatasstory(snapshot));
                })),
      ),
    );
  }

   GetDatasstory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewStory(doc.documentID);
                }));
              },
              child: new Container(
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
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('user')
                                      .document(doc["useruid"])
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
                                              .document(doc["useruid"])
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
                                        doc["created_at"],
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        (doc['image'] != null)
                            ? Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        image: NetworkImage(doc['image']),
                                        fit: BoxFit.cover)),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 10),
                              ),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: Text(
                              doc["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 20),
                            )),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite_border,
                                    size: 15,
                                  ),
                                  Text(" 1000")
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 15,
                                  ),
                                  Text(" 1000")
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ))
        .toList();
  }
}
