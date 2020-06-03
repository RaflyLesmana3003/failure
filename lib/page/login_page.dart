import 'package:failure/page/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                widget.auth.signIn().whenComplete(() async {
                  widget.loginCallback();
                });
              },
              highlightElevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Signin with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[850],
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
