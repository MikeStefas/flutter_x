import 'package:flutter/material.dart';
import 'package:myapp/pages/homePage/noDemographicPopup.dart';
import 'package:myapp/requests-funcs/viewDemographicData.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        await (viewDemographicDataRequest());
        final result = await viewDemographicDataRequest();
        if (result == null) {
          // Show alert dialog
          NoDemographicsPopup(context);
          return; // stop execution here
        }
        ;
        Navigator.pushNamed(context, '/startpage');
      },
      child: const Icon(Icons.camera_alt, size: 30),
    );
  }
}
