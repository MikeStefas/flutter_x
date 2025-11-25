import 'package:flutter/material.dart';
import 'package:myapp/util/info_box.dart';

class ShowMyData extends StatelessWidget {
  final int yob;
  final String gender;
  const ShowMyData({super.key, required this.yob, required this.gender});

  @override
  Widget build(BuildContext context) {
    return InfoBox(
      title: 'Your demographicData:',
      txt: 'Year of birth: $yob \nGender: $gender',
    );
  }
}
