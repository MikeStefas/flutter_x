import 'package:flutter/material.dart';
import 'package:myapp/util/data_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      //body
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 70)),
          const LoginTextArea(),
          const LoginForm(),
          const SignUpButton(),
        ],
      ),
    );
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
          child: DataField(
            dataController: usernameController,
            label: 'Username',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataField(
            dataController: passwordController,
            label: 'Password',
          ),
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
          Navigator.pushNamed(context, '/signuppage');
        },
        child: const Text('Sign Up'),
      ),
    );
  }
}

class LoginTextArea extends StatelessWidget {
  const LoginTextArea({super.key});
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
