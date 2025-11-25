import 'package:flutter/material.dart';
import 'package:myapp/requests-funcs/signIn_storeToken.dart';
import 'package:myapp/util/data_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signIn(String email, String password) async {
    String email = emailController.text;
    String password = passwordController.text;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: DataField(dataController: emailController, label: 'email'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataField(
            dataController: passwordController,
            label: 'password',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: FloatingActionButton(
            onPressed: () =>
                signIn(emailController.text, passwordController.text),
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.check, color: Colors.black, size: 30),
          ),
        ),
      ],
    );
  }
}
