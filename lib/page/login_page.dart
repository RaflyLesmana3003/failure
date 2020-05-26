import 'package:failure/model/user.dart';
import 'package:failure/page/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  bool _isLoginForm;

  @override
  void initState() {
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    double na = -MediaQuery.of(context).size.height * 0.01;

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: na,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  // Image(
                  //   image: AssetImage("assets/login.png"),
                  //   fit: BoxFit.cover,
                  // ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      children: <Widget>[
                        // Image(
                        //   image: AssetImage("assets/logo_bagikita_3.png"),
                        //   fit: BoxFit.cover,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Bersama, Kita basmi bencana Kelaparan."),
                  SizedBox(height: 50),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: ()  {
                      widget.auth.signIn().whenComplete(() async {
                        
                          
                          widget.loginCallback();
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Image(
                          //     image: AssetImage("assets/google_logo.png"),
                          //     height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'masuk dengan google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _showCircularProgress() {
  //   if (_isLoading) {
  //     return Center(child: CircularProgressIndicator());
  //   }
  //   return Container(
  //     height: 0.0,
  //     width: 0.0,
  //   );
  // }
}
