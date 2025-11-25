import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ignore: unused_import
import 'package:myapp/funcs/dataupload.dart';
import 'package:myapp/funcs/mediacapture.dart';
import 'package:myapp/funcs/popconfirmation.dart';
import 'package:myapp/pages/signinPage/signinpage.dart'; // ignore: unused_import
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:myapp/util/image_section.dart';
import 'package:myapp/util/video_section.dart';
import 'dart:io'; // ignore: unused_import
import 'package:path_provider/path_provider.dart'; // ignore: unused_import
import 'package:video_player/video_player.dart'; // ignore: unused_import
import 'package:archive/archive_io.dart'; // ignore: unused_import
import 'package:dartssh2/dartssh2.dart'; // ignore: unused_import
import 'package:intl/intl.dart'; // ignore: unused_import

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
        // Make onPopInvoked async
        if (didPop) {
          return;
        }
        // Call the external function here
        final bool shouldPop = await showPopConfirmationDialog(context);
        if (shouldPop) {
          Navigator.of(context).pop(); // Manually pop if confirmed
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar:
            const CommonAppBar(), // Assuming CommonAppBar is const or doesn't need hot reload
        body: const CaptureSection(),
        bottomNavigationBar: const CommonBotAppBar(),
      ),
    );
  }
}

// lib/pages/start_page.dart (Continuation of your file)

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

  // Lifecycle method to dispose of the video controller when the widget is removed
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // Modified methods to call external functions and pass setState
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
      (newController) => _videoController =
          newController, // Callback to update _videoController
      setState,
    );
  }

  Future<void> _sendDataHandler() async {
    setState(() => isSending = true); // Update local state for UI feedback

    final patientId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Unknown';

    await sendAllData(
      context: context,
      setStateCallback:
          setState, // Pass setState for internal updates (like clearing lists)
      tongueImages: tongueImages,
      teethImages: teethImages,
      swellingImages: swellingImages,
      solidVideo: solidVideo,
      liquidVideo: liquidVideo,
      mixedVideo: mixedVideo,
      setVideoControllerToNull: (controller) {
        _videoController?.dispose(); // Dispose current controller if any
        _videoController = controller; // Set to null
      },
      patientId: patientId,
    );

    setState(() => isSending = false); // Update local state after operation
  }

  // BUILDER
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
