import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:video_player/video_player.dart';
// ignore: unused_import
import 'dart:io';
/* 
  This section contains prebuilt widgets used solely for
  the LoginPage. LoginText and LoginForm!
*/

// LoginPage page widget
class LoginText extends StatelessWidget {
  const LoginText({super.key});
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
            'LoginForm in',
            style: TextStyle(fontSize: 27, color: Colors.lightBlueAccent),
          ),
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
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: ' Username',
              labelStyle: TextStyle(color: Colors.lightBlueAccent),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: ' Password',
              labelStyle: TextStyle(color: Colors.lightBlueAccent),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              setState(() {});
            },
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

/* 
  This section contains prebuilt widgets used throughout the app
  (Appbars, Buttons, BottomNavigationBar, etc.)
*/

// Common TextStyle for titles
const titleTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);
// Common BottomLine
var bottomLine = PreferredSize(
  preferredSize: const Size.fromHeight(2.0), // height of the line
  child: Container(
    color: Colors.lightBlueAccent, // line color
    height: 2.0,
  ),
);

// CommonAppBar widget
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);

  @override
  Widget build(BuildContext context) {
    var logoutIconButton = IconButton(
      icon: Icon(Icons.logout, color: Colors.lightBlueAccent),
      onPressed: () => Navigator.pushNamed(context, '/login'),
    );

    return AppBar(
      leading: logoutIconButton,
      backgroundColor: Colors.black,
      centerTitle: true,
      title: Text('SmileCheck', style: titleTextStyle),
      bottom: bottomLine,
    );
  }
}

// CommonBotAppBar widget
class CommonBotAppBar extends StatelessWidget {
  const CommonBotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // border line
        Container(height: 2, color: Colors.lightBlueAccent),
        //
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: BottomAppBar(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.info,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/infopage');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/historypage');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// CommonBoxDecoration for InfoBox
var commonBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.lightBlueAccent, width: 2),
);

// InfoBox widget
class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    const commonInfoBoxTextStyle = TextStyle(
      fontSize: 28,
      color: Colors.lightBlueAccent,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Container(
        decoration: commonBoxDecoration,
        alignment: Alignment.center,
        child: Text(
          "ΚΑΛΗΜΕΡΑ \n ΚΑΛΗΜΕΡΑ \n ΚΑΛΗΜΕΡΑ \n Διαφορες επεξηγήσεις με μικρότερα γραμματα, θα βγει πιο ωραάιο",
          style: commonInfoBoxTextStyle,
        ),
      ),
    );
  }
}
