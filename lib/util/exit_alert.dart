import 'package:flutter/material.dart';

class ExitAlert extends StatelessWidget {
  const ExitAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlueAccent,
      title: const Text("EXIT!"),
      content: const Text("Do you want to discard data?"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context), // User chose 'No'
          child: const Text("No"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            foregroundColor: Colors.black,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, '/homepage'), // User chose 'Yes'
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
