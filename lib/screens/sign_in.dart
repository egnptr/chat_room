import 'package:chat_room/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(85, 0, 0, 0),
              child: SignInButton(
                Buttons.Google,
                padding: EdgeInsets.all(5),
                onPressed: () => Auth().signInWithGoogle(context),
              ),
            )
          ]),
    );
  }
}
