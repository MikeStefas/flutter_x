import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Widget videoSection({
  required BuildContext context,
  required String title,
  required File? file,
  required void Function(File) setFile,
  required Future<void> Function(void Function(File)) setVideo,
  required VideoPlayerController? videoController,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.lightBlueAccent,
    child: Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        visualDensity: VisualDensity(),
        shape: RoundedRectangleBorder(),
        expansionAnimationStyle: AnimationStyle(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (file != null) Icon(Icons.check_circle, color: Colors.black),
          ],
        ),
        children: [
          if (file == null)
            ElevatedButton(
              onPressed: () => setVideo(setFile),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 103, 205, 253),
                foregroundColor: Colors.black,
              ),
              child: Text("Capture Video"),
            ),
          if (file != null)
            GestureDetector(
              onTap: () async {
                final replace = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.lightBlueAccent,
                    title: Text(
                      "Replace Video",
                      style: TextStyle(color: Colors.black),
                    ),
                    content: Text(
                      "Do you want to replace this video?",
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
                if (replace == true) await setVideo(setFile);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child:
                    (videoController != null &&
                        videoController.value.isInitialized)
                    ? AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController),
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        color: Colors.black,
                        child: Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
              ),
            ),
        ],
      ),
    ),
  );
}
