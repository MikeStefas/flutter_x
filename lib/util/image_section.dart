import 'dart:io';
import 'package:flutter/material.dart';

Widget imageSection({
  required BuildContext context,
  required String title,
  required List<File> images,
  required VoidCallback onAddImage,
  required void Function(int) onReplaceImage,
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
            Expanded(child: Text("$title (${images.length}/4)")),
            if (images.length == 4)
              Icon(Icons.check_circle, color: Colors.black),
          ],
        ),
        children: [
          if (images.length < 4)
            ElevatedButton(
              onPressed: onAddImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 103, 205, 253),
                foregroundColor: Colors.black,
              ),
              child: Text("Add Image"),
            ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: images
                .asMap()
                .entries
                .map(
                  (e) => GestureDetector(
                    onTap: () async {
                      final replace = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.lightBlueAccent,
                          title: Text(
                            "Replace Image",
                            style: TextStyle(color: Colors.black),
                          ),
                          content: Text(
                            "Do you want to replace this image?",
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
                      if (replace == true) onReplaceImage(e.key);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(e.value, fit: BoxFit.cover),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
}
