import 'package:flutter/material.dart';
import 'package:myapp/global-components/data-field.dart';
import 'package:myapp/actions/sign-in.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                signIn(emailController.text, passwordController.text, context),
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.check, color: Colors.black, size: 30),
          ),
        ),
      ],
    );
  }
}
