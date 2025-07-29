// lib/funcs/media_capture.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart'; // Needed for setState and VideoPlayerController

// Helper function to pick media (image or video)
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

// Function to add an image to a list
Future<void> addImage(
  ImagePicker picker,
  List<File> storage,
  StateSetter setStateCallback, // Pass setState from the State
) async {
  if (storage.length >= 4) return;
  final file = await pickMedia(picker, ImageSource.camera);
  if (file != null) setStateCallback(() => storage.add(file));
}

// Function to replace an image in a list
Future<void> replaceImage(
  ImagePicker picker,
  List<File> storage,
  int index,
  StateSetter setStateCallback, // Pass setState from the State
) async {
  final file = await pickMedia(picker, ImageSource.camera);
  if (file != null) setStateCallback(() => storage[index] = file);
}

// Function to set a video file and initialize its controller
Future<void> setVideo(
  ImagePicker picker,
  Function(File)
  setFileCallback, // Function to set the video file (e.g., solidVideo = f)
  VideoPlayerController? currentVideoController,
  Function(VideoPlayerController?)
  setVideoControllerCallback, // Function to set the controller
  StateSetter setStateCallback, // Pass setState from the State
) async {
  final file = await pickMedia(picker, ImageSource.camera, isVideo: true);
  if (file != null) {
    setStateCallback(() => setFileCallback(file)); // Update the video file
    currentVideoController?.dispose(); // Dispose old controller
    final newController = VideoPlayerController.file(file)
      ..initialize().then(
        (_) => setStateCallback(() {}),
      ); // Initialize new controller
    setStateCallback(
      () => setVideoControllerCallback(newController),
    ); // Update the controller
  }
}
