import 'package:flutter/material.dart';
import 'package:myapp/requests-funcs/logoutfunc.dart';
import 'package:myapp/util/exit_alert.dart';

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
          // *** THIS IS THE CRUCIAL CHANGE ***
          showDialog<bool>(
            // Specify <bool> to indicate the type of value the dialog returns
            context: context,
            builder: (BuildContext dialogContext) {
              // Use a different context for the dialog
              return ExitAlert();
            },
          );
        },
      );
    } else {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.lightBlueAccent),
        onPressed: () {
          Navigator.pop(context); // Go back to the previous route
        },
      );
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
