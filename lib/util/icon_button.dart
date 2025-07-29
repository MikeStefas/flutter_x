import 'package:flutter/material.dart';

class IconButton extends StatelessWidget {
  const IconButton({super.key, required this.icon, required this.onPressed});

  final Function onPressed;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
      ),
      onPressed: onPressed(),
      child: icon,
    );
  }
}
