import 'package:flutter/material.dart';
import 'package:myapp/pages/home-page/home-page.dart';
import 'package:myapp/pages/signin-page/signin-page.dart';
import 'package:myapp/pages/info-page/info-page.dart';
import 'package:myapp/pages/start-page/start-page.dart';
import 'package:myapp/pages/history-page/history-page.dart';
import 'package:myapp/pages/demographic-data-page/demographic-data-page.dart';
import 'package:myapp/actions/tokens-exist.dart';

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
