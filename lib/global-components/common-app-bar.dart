import 'package:flutter/material.dart';
import 'package:myapp/actions/logout-func.dart';
import 'package:myapp/global-components/exit-alert.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2.0);

  @override
  Widget build(BuildContext context) {
    final currentRouteName = ModalRoute.of(context)?.settings.name;

    final isHomePage = currentRouteName == '/homepage';
    final isStartPage = currentRouteName == '/startpage';
    Widget? leadingWidget;
    if (isHomePage) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.logout, color: Colors.lightBlueAccent),
        onPressed: () {
          logout();
          Navigator.pushNamed(context, '/signinpage');
        },
      );
    } else if (isStartPage) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.lightBlueAccent),
        onPressed: () {
          showDialog<bool>(
            context: context,
            builder: (BuildContext dialogContext) {
              return ExitAlert();
            },
          );
        },
      );
    } else {
      leadingWidget = Icon(Icons.abc, color: Colors.transparent);
    }

    return AppBar(
      leading:
          leadingWidget, // This will be null if not homepage, effectively hiding it
      backgroundColor: Colors.black,
      centerTitle: true,
      title: const Text('SmileCheck', style: titleTextStyle),
      bottom: bottomLine,
    );
  }
}

// Common BottomLine
var bottomLine = PreferredSize(
  preferredSize: const Size.fromHeight(2.0), // height of the line
  child: Container(
    color: Colors.lightBlueAccent, // line color
    height: 2.0,
  ),
);

// Common TextStyle for titles
const titleTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);
