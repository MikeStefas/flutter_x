import 'package:flutter/material.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:myapp/pages/signinpage.dart';
import 'package:myapp/pages/infopage.dart';
import 'package:myapp/pages/startpage.dart';
import 'package:myapp/pages/historypage.dart';
import 'package:myapp/pages/datapage.dart';

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
      home: const SignInPage(),
      routes: {
        '/signinpage': (context) => const SignInPage(),
        '/homepage': (context) => const HomePage(),
        '/infopage': (context) => const InfoPage(),
        '/startpage': (context) => StartPage(),
        '/historypage': (context) => const HistoryPage(reports: []),
        '/datapage': (context) => const DataPage(),
      },
    );
  }
}
