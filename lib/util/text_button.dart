import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  const TextButton({super.key, required this.txt, required this.onPressed});

  final Function onPressed;
  final String txt;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(txt),
    );
  }
}
