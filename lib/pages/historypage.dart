import 'package:flutter/material.dart';
import 'package:myapp/pages/startpage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.lightBlueAccent),
          onPressed: () => Navigator.pushNamed(context, '/login'),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'SmileCheck',
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // height of the line
          child: Container(
            color: Colors.lightBlueAccent, // line color
            height: 2.0,
          ),
        ),
      ),
      body: History(),
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
