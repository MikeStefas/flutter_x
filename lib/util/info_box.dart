import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String txt;
  final String title;

  const InfoBox({super.key, required this.title, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Container(
        decoration: commonBoxDecoration,
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(title, style: commonInfoBoxTitleStyle),
            Text(txt, style: commonInfoBoxTextStyle),
          ],
        ),
      ),
    );
  }
}

// CommonBoxDecoration for InfoBox
var commonBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.lightBlueAccent, width: 2),
);

const commonInfoBoxTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
);

const commonInfoBoxTitleStyle = TextStyle(
  fontSize: 34,
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
);
