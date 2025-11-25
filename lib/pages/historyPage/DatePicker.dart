import 'package:flutter/material.dart';

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
