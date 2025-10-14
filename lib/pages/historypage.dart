import 'package:flutter/material.dart';
import 'package:myapp/requests-funcs/viewUserReports.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
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

class reportsListBuilder extends StatelessWidget {
  const reportsListBuilder({
    super.key,
    required this.reports,
    required this.selectedDate,
  });
  final List<dynamic> reports;
  final DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
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
              //show date
              DateTime.parse(
                    reports[index]['createdAt'],
                  ).toString().split(':')[0] +
                  ':' +
                  DateTime.parse(
                    reports[index]['createdAt'],
                  ).toString().split(':')[1].substring(0, 2),
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.filterReports,
  });
  final Function() filterReports;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected; // 👈 Callback to parent

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),

      // Dark mode picker style
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.lightBlueAccent,
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.lightBlueAccent,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      widget.onDateSelected(pickedDate); // 👈 Notify parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: <Widget>[
          Text(
            widget.selectedDate != null
                ? 'Selected Date: ${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
                : 'No date selected',
            style: const TextStyle(color: Colors.lightBlueAccent),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.black,
              side: const BorderSide(color: Colors.lightBlueAccent),
            ),
            onPressed: () async {
              await _selectDate();
              widget.filterReports();
            },
            child: const Text(
              'Select Date',
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
