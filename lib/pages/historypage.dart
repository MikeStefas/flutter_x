import 'package:flutter/material.dart';
import 'package:myapp/pages/startpage.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),

      //BODY
      body: History(),

      bottomNavigationBar: CommonBotAppBar(),
      backgroundColor: Colors.black,
    );
  }
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int len = videocounterG;

  @override
  Widget build(BuildContext context) {
    //TODO FIX THIS
    return ListView.builder(
      itemCount: len,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.history, color: Colors.lightBlueAccent),
            title: Text(
              'History Item $index',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              'Details for item $index',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
