import 'package:flutter/material.dart';
import 'package:myapp/requests-funcs/viewUserReports.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

var reports = [];

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.reports});
  final List<dynamic> reports;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),

      //BODY
      body: History(reports: widget.reports),

      bottomNavigationBar: CommonBotAppBar(),
      backgroundColor: Colors.black,
    );
  }
}

class History extends StatefulWidget {
  const History({super.key, required this.reports});
  final List<dynamic> reports;
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int len = reports.length;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
    setState(() {});
  }

  Future<void> _loadReports() async {
    final fetchedReports = await viewUserReportsRequest();
    setState(() {
      reports = fetchedReports;
    });
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: len,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.black,
          shape: (RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.lightBlueAccent),
          )),
          child: ListTile(
            leading: Icon(Icons.history, color: Colors.lightBlueAccent),
            title: Text(
              reports[index]['createdAt'].split('T')[0],
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
            subtitle: Text(
              '''tongue: ${reports[index]['tongue']} - ${reports[index]['tonguePercentage']}%
teeth: ${reports[index]['teeth']} - ${reports[index]['teethPercentage']}%
saliva: ${reports[index]['saliva']} - ${reports[index]['salivaPercentage']}%
pain: ${reports[index]['pain']} - ${reports[index]['painPercentage']}%''',
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
          ),
        );
      },
    );
  }
}
