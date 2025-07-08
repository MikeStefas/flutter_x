import 'package:flutter/material.dart';
import 'package:myapp/pages/prebuiltwidgets.dart';

// LoginFormin page widget
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [const LoginText(), const LoginForm()],
      ),
    );
  }
}
