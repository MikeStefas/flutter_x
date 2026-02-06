import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/actions/data-upload.dart';
import 'package:myapp/actions/media-capture.dart';
import 'package:myapp/actions/pop-confirmation.dart';
import 'package:myapp/global-components/common-app-bar.dart';
import 'package:myapp/global-components/common-bot-app-bar.dart';
import 'package:myapp/pages/start-page/components/image-section.dart';
import 'package:myapp/pages/start-page/components/video-section.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

int videocounterG = 0;
// Save the counter when the app is closing

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // Remove the _onWillPop function from here

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showPopConfirmationDialog(context);
        if (shouldPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const CommonAppBar(),
        body: const CaptureSection(),
        bottomNavigationBar: const CommonBotAppBar(),
      ),
    );
  }
}

class CaptureSection extends StatefulWidget {
  const CaptureSection({super.key});
  @override
  State<CaptureSection> createState() => _CaptureSectionState();
}

class _CaptureSectionState extends State<CaptureSection> {
  // LOGIC, FUNCTONS, VARIABLES AND WIDGETS USED FOR CAMERA CAPTURE
  final ImagePicker _picker = ImagePicker();
  List<File> tongueImages = [], teethImages = [], swellingImages = [];
  File? solidVideo, liquidVideo, mixedVideo;
  VideoPlayerController? _videoController;
  bool isSending = false;

  bool get allCollected =>
      tongueImages.length == 4 &&
      teethImages.length == 4 &&
      swellingImages.length == 4 &&
      solidVideo != null &&
      liquidVideo != null &&
      mixedVideo != null;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _addImageHandler(List<File> storage) async {
    await addImage(_picker, storage, setState);
  }

  Future<void> _replaceImageHandler(List<File> storage, int index) async {
    await replaceImage(_picker, storage, index, setState);
  }

  Future<void> _setVideoHandler(Function(File) setFile) async {
    await setVideo(
      _picker,
      setFile,
      _videoController,
      (newController) => _videoController = newController,
      setState,
    );
  }

  Future<void> _sendDataHandler() async {
    setState(() => isSending = true);

    final patientId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Unknown';

    await sendAllData(
      context: context,
      setStateCallback: setState,
      tongueImages: tongueImages,
      teethImages: teethImages,
      swellingImages: swellingImages,
      solidVideo: solidVideo,
      liquidVideo: liquidVideo,
      mixedVideo: mixedVideo,
      setVideoControllerToNull: (controller) {
        _videoController?.dispose();
        _videoController = controller;
      },
      patientId: patientId,
    );

    setState(() => isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Step 1: Capture Tongue Images",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  imageSection(
                    context: context,
                    title: "Tongue Images",
                    images: tongueImages,
                    onAddImage: () => _addImageHandler(tongueImages),
                    onReplaceImage: (index) =>
                        _replaceImageHandler(tongueImages, index),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Step 2: Capture Teeth Images",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  imageSection(
                    context: context,
                    title: "Teeth Images",
                    images: teethImages,
                    onAddImage: () => _addImageHandler(teethImages),
                    onReplaceImage: (index) =>
                        _replaceImageHandler(teethImages, index),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Step 3: Capture Swelling Images",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  imageSection(
                    context: context,
                    title: "Swelling Images",
                    images: swellingImages,
                    onAddImage: () => _addImageHandler(swellingImages),
                    onReplaceImage: (index) =>
                        _replaceImageHandler(swellingImages, index),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Step 4: Record Solid Swallow Video",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  videoSection(
                    context: context,
                    title: "Solid Swallow Video",
                    file: solidVideo,
                    setFile: (f) =>
                        setState(() => solidVideo = f), // Direct setState here
                    setVideo: (Function(File) setFile) =>
                        _setVideoHandler(setFile), // Pass through
                    videoController: _videoController,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Step 5: Record Liquid Swallow Video",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  videoSection(
                    context: context,
                    title: "Liquid Swallow Video",
                    file: liquidVideo,
                    setFile: (f) =>
                        setState(() => liquidVideo = f), // Direct setState here
                    setVideo: (Function(File) setFile) =>
                        _setVideoHandler(setFile), // Pass through
                    videoController: _videoController,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Step 6: Record Mixed Swallow Video",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  videoSection(
                    context: context,
                    title: "Mixed Swallow Video",
                    file: mixedVideo,
                    setFile: (f) =>
                        setState(() => mixedVideo = f), // Direct setState here
                    setVideo: (Function(File) setFile) =>
                        _setVideoHandler(setFile), // Pass through
                    videoController: _videoController,
                  ),
                  const SizedBox(height: 20),
                  isSending
                      ? Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text(
                              "Uploading...",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        )
                      : ElevatedButton.icon(
                          onPressed: allCollected ? _sendDataHandler : null,
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text("Send Data"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            foregroundColor: Colors.black,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
