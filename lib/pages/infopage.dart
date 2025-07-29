import 'package:flutter/material.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:myapp/util/info_box.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(),
      body: InfoPageBody(),
      bottomNavigationBar: CommonBotAppBar(),
    );
  }
}

class InfoPageBody extends StatelessWidget {
  const InfoPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        InfoBox(title: '1)click stuff', txt: 'idk sum stuff will be here'),
        InfoBox(
          title: '2)click more stuff',
          txt: 'Hello World of reusable custom widgets!',
        ),
      ],
    );
  }
}
