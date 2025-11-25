import 'package:flutter/material.dart';

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
