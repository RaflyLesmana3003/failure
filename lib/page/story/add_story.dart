import 'package:dotted_border/dotted_border.dart';
import 'package:failure/model/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snackbar/flutter_snackbar.dart';
import 'package:image_picker/image_picker.dart'; // access to jsonEncode()
import 'package:quill_delta/quill_delta.dart';
import 'dart:io';

import 'package:zefyr/zefyr.dart'; // access to File and Directory classes

class AddStory extends StatefulWidget {
  AddStory({this.fail, this.insight});
  final NotusDocument fail;
  final NotusDocument insight;

  @override
  _AddStoryState createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  ScrollController _scrollController = new ScrollController();

  ZefyrController _insightcontroller;
  FocusNode _insightfocusNode;

  ZefyrController _storyzcontroller;
  FocusNode _storyfocusNode;

  File imagefile;
  TextEditingController title = TextEditingController();
  FocusNode _titlefocus;
  GlobalKey<SnackBarWidgetState> _globalKey = GlobalKey();
  int count = 0;
  int click = 1;
  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _insightfocusNode = FocusNode();
    _storyfocusNode = FocusNode();
    _titlefocus = FocusNode();
    _loadDocument(widget.fail).then((document) {
      setState(() {
        _storyzcontroller = ZefyrController(document);
      });
    });
    _loadDocument(widget.insight).then((document) {
      setState(() {
        _insightcontroller = ZefyrController(document);
      });
    });
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagefile = picture;
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

    final storyeditor = ZefyrField(
      height: MediaQuery.of(context).size.height,
      // set the editor's height
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "share your awesome story here!",
        // labelText: "story",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[400],
          ),
        ),
      ),
      controller: _storyzcontroller,
      focusNode: _storyfocusNode,
      autofocus: false,
      physics: ScrollPhysics(),
    );

    final insighteditor = ZefyrField(
      height: MediaQuery.of(context).size.height / 2,
// set the editor's height
      decoration: InputDecoration(
        hasFloatingPlaceholder: true,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: "get any insight?, if you dont, dont worry!",
        // labelText: "story",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[400],
          ),
        ),
      ),
      controller: _insightcontroller,
      focusNode: _insightfocusNode,
      autofocus: false,
      physics: ClampingScrollPhysics(),
    );

    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: new Scaffold(
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: (click == 1)
                ? FloatingActionButton.extended(
                    label: Text("Publish"),
                    backgroundColor: Colors.pinkAccent[400],
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      
                      if (title.text.length == 0) {
                        _titlefocus.requestFocus();
                      _globalKey.currentState.show("Title must not be empty");

                        return false;
                      }
                      if (_storyzcontroller.document.length == 1) {
                        _storyfocusNode.requestFocus();
                        setState(() {
                          click = 1;
                        });
                      _globalKey.currentState.show("Story must not be empty");

                        return false;
                      }
                      setState(() {
                        click = 0;
                      });
                      StoryModel().createdraftStory(
                          image: imagefile,
                          title: title.text,
                          story: _storyzcontroller.document,
                          insight: _insightcontroller.document).then((onValue){
                            Navigator.pop(context);
                          });
                    },
                  )
                : FloatingActionButton(
                  onPressed: (){},
                  backgroundColor: Colors.pinkAccent[400],
                  child: CircularProgressIndicator(backgroundColor: Colors.white,valueColor: new AlwaysStoppedAnimation<Color>(Colors.pinkAccent[700])),
                )),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Text("New Story"),
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
        body: SnackBarWidget(
          key: _globalKey,
          textBuilder: (String message) {
            return Text(message ?? "",
                style: TextStyle(color: Colors.white, fontSize: 16.0));
          },
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Colors.redAccent),
          content: ZefyrScaffold(
            child: Container(
              margin: EdgeInsets.all(10),
              child: new ListView(
                controller: _scrollController,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showchoicedialog(context);
                    },
                    child: DottedBorder(
                      color: Colors.grey[400],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      padding: EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Center(
                            child: (imagefile == null)
                                ? Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    child: Center(
                                        child: Text("Image not selected")),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(imagefile),
                                          fit: BoxFit.cover),
                                    ),
                                  )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextFormField(
                      onChanged: (title) {
                        setState(() {});
                      },
                      maxLength: 32,
                      cursorColor: Colors.pinkAccent[100],
                      controller: title,
                      focusNode: _titlefocus,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: "Title *",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.pinkAccent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    child: new TabBar(
                      controller: _controller,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.pinkAccent[400],
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.pinkAccent[400],
                      onTap: (args) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      tabs: [
                        new Tab(
                          text: 'Story *',
                        ),
                        new Tab(
                          text: 'Insight',
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height / 2,
                    margin: EdgeInsets.only(top: 10),
                    child: new TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        Container(child: storyeditor),
                        Container(child: insighteditor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<NotusDocument> _loadDocument(NotusDocument content) async {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
