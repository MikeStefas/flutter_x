import 'package:flutter/material.dart';
import 'package:myapp/pages/home-page/info-button.dart';
import 'package:myapp/pages/home-page/start-button.dart';
import 'package:myapp/global-components/common-app-bar.dart';
import 'package:myapp/global-components/common-bot-app-bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(),
      body: HomePageBody(),
      bottomNavigationBar: CommonBotAppBar(),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'SmileCheck',
            style: TextStyle(fontSize: 28, color: Colors.lightBlueAccent),
          ),
          const SizedBox(height: 20),

          // button
          StartButton(),
          InfoButton(),
        ],
      ),
    );
  }
}
