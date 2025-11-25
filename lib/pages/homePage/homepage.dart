import 'package:flutter/material.dart';
import 'package:myapp/pages/homePage/infoButton.dart';
import 'package:myapp/pages/homePage/startButton.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';

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
          Container(height: 20),
          InfoButton(),
        ],
      ),
    );
  }
}
