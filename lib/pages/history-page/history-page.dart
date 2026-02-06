import 'package:flutter/material.dart';
import 'package:myapp/pages/history-page/components/date-picker.dart';
import 'package:myapp/pages/history-page/components/reports-list-builder.dart';
import 'package:myapp/requests/view-user-reports.dart';
import 'package:myapp/global-components/common-app-bar.dart';
import 'package:myapp/global-components/common-bot-app-bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.reports,
    required this.selectedDate,
  });
  final List<dynamic> reports;
  final DateTime? selectedDate;
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),

      //BODY
      body: History(reports: widget.reports, selectedDate: widget.selectedDate),

      bottomNavigationBar: CommonBotAppBar(),
      backgroundColor: Colors.black,
    );
  }
}

class History extends StatefulWidget {
  const History({super.key, required this.reports, required this.selectedDate});
  final List<dynamic> reports;
  final DateTime? selectedDate;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> reports = [];
  DateTime? selectedDate;

  @override
  //stat
  void initState() {
    super.initState();
    () async {
      //fixed bug that would keep user1 reports if u logged in with user2 who has no reports
      setState(() {
        reports = [];
      });
      await _loadReports();
      //sort by neqest first
      reports.sort((a, b) {
        DateTime dateA = DateTime.parse(a['createdAt']);
        DateTime dateB = DateTime.parse(b['createdAt']);
        return dateB.compareTo(dateA);
      });
      setState(() {
        reports = reports;
      });
    }();
  }

  Future<void> _loadReports() async {
    final fetchedReports = await viewUserReportsRequest();

    reports = fetchedReports;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void filterReports() async {
    List<dynamic> filteredReportsList = [];
    DateTime formattedDate = DateTime.parse(
      selectedDate.toString().split(' ')[0],
    );
    for (var report in reports) {
      if (report['createdAt'].split('T')[0] ==
          formattedDate.toString().split(' ')[0]) {
        filteredReportsList.add(report);
      }
    }
    setState(() {
      reports = filteredReportsList;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        DatePicker(
          selectedDate: selectedDate,
          onDateSelected: _onDateSelected,
          filterReports: filterReports,
        ),
        Expanded(
          child: reportsListBuilder(
            reports: reports,
            selectedDate: selectedDate,
          ),
        ),
      ],
    );
  }
}
