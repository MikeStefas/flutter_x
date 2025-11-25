import 'package:flutter/material.dart';
import 'package:myapp/pages/homePage/homepage.dart';
import 'package:myapp/pages/signinPage/signinpage.dart';
import 'package:myapp/pages/infoPage/infopage.dart';
import 'package:myapp/pages/startpage.dart';
import 'package:myapp/pages/historyPage/historypage.dart';
import 'package:myapp/pages/demographicDataPage/demographicDatapage.dart';
import 'package:myapp/requests-funcs/tokensExist.dart';

void main() {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmileCheck',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: FutureBuilder<bool>(
        future: tokensExist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!) {
            return const HomePage();
          } else {
            return const SignInPage();
          }
        },
      ),
      routes: {
        '/signinpage': (context) => const SignInPage(),
        '/homepage': (context) => const HomePage(),
        '/infopage': (context) => const InfoPage(),
        '/startpage': (context) => StartPage(),
        '/historypage': (context) =>
            const HistoryPage(reports: [], selectedDate: null),
        '/demographicDatapage': (context) => const DataPage(),
      },
    );
  }
}
