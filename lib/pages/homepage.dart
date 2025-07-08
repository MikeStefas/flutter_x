import 'package:flutter/material.dart';
import 'package:myapp/pages/prebuiltwidgets.dart';

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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/startpage');
            },
            child: const Icon(Icons.camera_alt, size: 30),
          ),
        ],
      ),
    );
  }
}
