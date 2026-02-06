import 'package:flutter/material.dart';
import 'package:myapp/global-components/info-box.dart';

class ShowMyData extends StatelessWidget {
  final int yob;
  final String gender;
  final bool hasDemographics;
  const ShowMyData({
    super.key,
    required this.yob,
    required this.gender,
    required this.hasDemographics,
  });

  @override
  Widget build(BuildContext context) {
    if (hasDemographics == false) {
      return InfoBox(
        title: 'Your demographicData:',
        txt: 'You have not uploaded demographic data yet.',
      );
    } else {
      return InfoBox(
        title: 'Your demographicData:',
        txt: 'Year of birth: $yob \nGender: $gender',
      );
    }
  }
}
