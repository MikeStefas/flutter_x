import 'package:flutter/material.dart';

Future<dynamic> NoDemographicsPopup(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text("Notice"),
        content: const Text("Upload your demographic data"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
