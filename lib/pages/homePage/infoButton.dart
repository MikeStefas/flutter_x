import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: const CircleBorder(),
      ),
      onPressed: () => {Navigator.pushNamed(context, '/infopage')},
      child: Icon(Icons.info, size: 30),
    );
  }
}
