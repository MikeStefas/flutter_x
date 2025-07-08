import 'package:flutter/material.dart';
import 'package:myapp/pages/prebuiltwidgets.dart';

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
      children: [InfoBox(), InfoBox(), InfoBox()],
    );
  }
}
