import 'package:failure/model/story.dart';
import 'package:failure/page/home/story.dart';
import 'package:failure/page/story/add_story.dart';
import 'package:flutter/material.dart';

class YourStory extends StatefulWidget {
  @override
  _YourStoryState createState() => _YourStoryState();
}

class _YourStoryState extends State<YourStory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.pinkAccent[400]),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Text("Your story"),
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
            label: Text("New story"),
            icon: Icon(Icons.add),
            backgroundColor: Colors.pinkAccent[400],
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddStory();
            })),
          ),
        ),
        body: YourStoryData(),
      ),
    );
  }
}
