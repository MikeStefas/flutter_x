import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

Future<File?> pickMedia(
  ImagePicker picker,
  ImageSource source, {
  bool isVideo = false,
}) async {
  final picked = isVideo
      ? await picker.pickVideo(source: source)
      : await picker.pickImage(source: source);
  if (picked == null) return null;
  final dir = await getApplicationDocumentsDirectory();
  return File(picked.path).copy('${dir.path}/${picked.name}');
}

Future<void> addImage(
  ImagePicker picker,
  List<File> storage,
  StateSetter setStateCallback,
) async {
  if (storage.length >= 4) return;
  final file = await pickMedia(picker, ImageSource.camera);
  if (file != null) setStateCallback(() => storage.add(file));
}

Future<void> replaceImage(
  ImagePicker picker,
  List<File> storage,
  int index,
  StateSetter setStateCallback,
) async {
  final file = await pickMedia(picker, ImageSource.camera);
  if (file != null) setStateCallback(() => storage[index] = file);
}

Future<void> setVideo(
  ImagePicker picker,
  Function(File)
  setFileCallback,
  VideoPlayerController? currentVideoController,
  Function(VideoPlayerController?)
  setVideoControllerCallback,
  StateSetter setStateCallback,
) async {
  final file = await pickMedia(picker, ImageSource.camera, isVideo: true);
  if (file != null) {
    setStateCallback(() => setFileCallback(file));
    currentVideoController?.dispose();
    final newController = VideoPlayerController.file(file)
      ..initialize().then(
        (_) => setStateCallback(() {}),
      );
    setStateCallback(
      () => setVideoControllerCallback(newController),
    );
  }
}
