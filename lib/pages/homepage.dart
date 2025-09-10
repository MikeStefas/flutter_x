import 'package:flutter/material.dart';
import 'package:myapp/requests-funcs/viewDemographicData.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(),
      body: HomePageBody(),
      bottomNavigationBar: CommonBotAppBar(),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'SmileCheck',
            style: TextStyle(fontSize: 28, color: Colors.lightBlueAccent),
          ),
          const SizedBox(height: 20),

          // button
          StartButton(),
          Container(height: 20),
          InfoButton(),
        ],
      ),
    );
  }
}

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
}
