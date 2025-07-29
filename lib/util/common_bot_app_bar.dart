import 'package:flutter/material.dart';

class CommonBotAppBar extends StatelessWidget {
  const CommonBotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // border line
        Container(height: 2, color: Colors.lightBlueAccent),
        //
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: BottomAppBar(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.info,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/infopage');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/historypage');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.data_saver_on,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/datapage');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
