import 'package:flutter/material.dart';
import 'package:myapp/pages/signinPage/SignInTextArea.dart';
import 'package:myapp/pages/signinPage/signinForm.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      //body
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 70)),
          const SignInTextArea(),
          const SignInForm(),
        ],
      ),
    );
  }
}

// SignInPage form
