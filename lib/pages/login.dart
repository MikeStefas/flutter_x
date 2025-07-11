import 'package:flutter/material.dart';
import 'package:myapp/pages/prebuiltwidgets.dart';

// LoginFormin page widget
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const Gap(),
          const LoginText(),
          const LoginForm(),
          const SignUpButton(),
        ],
      ),
    );
  }
}

class Gap extends StatelessWidget {
  const Gap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 70));
  }
}

// LoginPage form
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void greet() {
    String username = usernameController.text;
    String password = passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter username and password!',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
      return;
    } else {
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
          child: UsernameField(usernameController: usernameController),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: PasswordField(passwordController: passwordController),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: FloatingActionButton(
            onPressed: greet,
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.check, color: Colors.black, size: 30),
          ),
        ),
      ],
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(120, 80, 120, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.black,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: const Text('Sign Up'),
      ),
    );
  }
}
