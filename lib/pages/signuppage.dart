import 'package:flutter/material.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/data_field.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(),
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Proceed with sign-up logic

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.5),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //components of body
            DataField(dataController: usernameController, label: 'Username'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            DataField(dataController: passwordController, label: 'Password'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            DataField(
              dataController: confirmPasswordController,
              label: 'Confirm Password',
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            DataField(dataController: firstNameController, label: 'First Name'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            DataField(dataController: lastNameController, label: 'Last Name'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            ConfirmButton(onPressed: _passwordConfirm),
          ],
        ),
      ),
    );
  }

  //function
  void _passwordConfirm() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (usernameController.text.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter usernameand password!',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Passwords do not match!',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
      return;
    }
    Navigator.pushNamed(context, '/homepage');
  }
}

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
      ),
      child: const Text('Confirm'),
    );
  }
}
