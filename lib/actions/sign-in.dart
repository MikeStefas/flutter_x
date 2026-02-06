import 'package:flutter/material.dart';
import 'package:myapp/requests/sign-in-store-token.dart';

signIn(String email, String password, BuildContext context) async {
  //empty fields
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Enter email and password!',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
    return;
  }
  final dynamic response = await signInRequest(email, password);
  //errors!
  if (response != null) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.lightBlueAccent,
        content: Text(response, style: TextStyle(color: Colors.black)),
      ),
    );
  } //success!
  else {
    Navigator.pushNamed(context, '/homepage');
  }
}
