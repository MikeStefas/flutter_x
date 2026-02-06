import 'package:flutter/material.dart';

class SignInTextArea extends StatelessWidget {
  const SignInTextArea({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'SmileCheck',
            style: TextStyle(
              fontSize: 34,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Log In',
            style: TextStyle(fontSize: 27, color: Colors.lightBlueAccent),
          ),
        ],
      ),
    );
  }
}
