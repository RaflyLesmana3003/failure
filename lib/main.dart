import 'package:failure/page/home/home.dart';
import 'package:failure/page/profile/profile.dart';
import 'package:failure/page/root_page.dart';
import 'package:failure/page/services/authentication.dart';
import 'package:failure/page/story/your_story.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'sinaubareng',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Colors.pinkAccent[400],
          textColor: Colors.pinkAccent[400],
          inactiveIconColor: Colors.grey,
          tabs: [
            TabData(
              iconData: Icons.bookmark_border,
              title: "Story",
            ),
            TabData(
              iconData: Icons.add_circle_outline,
              title: "Your Story",
            ),
            TabData(iconData: Icons.person_outline, title: "Basket")
          ],
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return HomePage();
      case 1:
        return YourStory();
      case 2:
        return Profile();
      default:
        return Container();
    }
  }
}
