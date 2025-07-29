import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ignore: unused_import
import 'package:myapp/pages/login.dart'; // ignore: unused_import
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:myapp/util/exit_alert.dart';
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
  Future<bool> _onWillPop() async {
    // Show the confirmation dialog
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ALERT();
      },
    );

    // If shouldDiscard is true, allow the page to pop (discard data)
    // If shouldDiscard is false or null (dialog dismissed), prevent the page from popping
    return shouldDiscard ??
        false; // Return false if dialog is dismissed without a choice
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent automatic popping
      onPopInvoked: (didPop) {
        if (didPop) {
          return; // The pop gesture was successful.
        }
        _onWillPop(); // Show the dialog for Android back button
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CommonAppBar(),
        // Add a body or other widgets here if needed
        body: CaptureSection(),
        bottomNavigationBar: CommonBotAppBar(),
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
  /* 
  LOGIC, FUNCTONS, VARIABLES AND WIDGETS USED FOR CAMERA CAPTURE
  BUILDER STARTS AT LINE 211
*/
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

  Future<File?> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final picked = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);
    if (picked == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    return File(picked.path).copy('${dir.path}/${picked.name}');
  }

  Future<void> _addImage(List<File> storage) async {
    if (storage.length >= 4) return;
    final file = await _pickMedia(ImageSource.camera);
    if (file != null) setState(() => storage.add(file));
  }

  Future<void> _replaceImage(List<File> storage, int index) async {
    final file = await _pickMedia(ImageSource.camera);
    if (file != null) setState(() => storage[index] = file);
  }

  Future<void> _setVideo(Function(File) setFile) async {
    final file = await _pickMedia(ImageSource.camera, isVideo: true);
    if (file != null) {
      setState(() => setFile(file));
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file)
        ..initialize().then((_) => setState(() {}));
    }
  }

  Future<bool> _checkRemoteExists(String path) async {
    try {
      final socket = await SSHSocket.connect("195.251.199.65", 3038);
      final client = SSHClient(
        socket,
        username: 'medadmin',
        onPasswordRequest: () => '11Medlab22!!',
      );
      final sftp = await client.sftp();
      final exists = await sftp
          .stat(path)
          .then((_) => true)
          .catchError((_) => false);
      client.close();
      return exists;
    } catch (_) {
      return false;
    }
  }

  Future<void> sendData() async {
    setState(() => isSending = true);
    final dir = await getApplicationDocumentsDirectory();
    final patientId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Unknown';
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final zipName = '$patientId-$date.zip';
    final zipPath = '${dir.path}/$zipName';

    final zip = ZipFileEncoder();
    zip.create(zipPath);
    for (var i = 0; i < 4; i++) {
      zip.addFile(tongueImages[i], 'tongue_image_${i + 1}.jpg');
      zip.addFile(teethImages[i], 'teeth_image_${i + 1}.jpg');
      zip.addFile(swellingImages[i], 'swelling_image_${i + 1}.jpg');
    }
    if (solidVideo != null) zip.addFile(solidVideo!, 'solid_swallow.mp4');
    if (liquidVideo != null) zip.addFile(liquidVideo!, 'liquid_swallow.mp4');
    if (mixedVideo != null) zip.addFile(mixedVideo!, 'mixed_swallow.mp4');
    zip.close();

    final remotePath = '/home/medadmin/Documents/$zipName';
    if (await _checkRemoteExists(remotePath)) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Replace Existing Data?"),
          content: Text("Data already exists for this patient today. Replace?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Yes"),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        setState(() => isSending = false);
        return;
      }
    }

    try {
      final socket = await SSHSocket.connect("195.251.199.65", 3038);
      final client = SSHClient(
        socket,
        username: 'medadmin',
        onPasswordRequest: () => '11Medlab22!!',
      );
      final sftp = await client.sftp();
      final file = File(zipPath);
      final remoteFile = await sftp.open(
        remotePath,
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
      );
      await remoteFile.write(Stream.value(await file.readAsBytes()));
      await remoteFile.close();
      client.close();

      setState(() {
        tongueImages.clear();
        teethImages.clear();
        swellingImages.clear();
        solidVideo = null;
        liquidVideo = null;
        mixedVideo = null;
        _videoController?.dispose();
        _videoController = null;
      });

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("Upload completed successfully."),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Upload failed: $e")));
    }
    setState(() => isSending = false);
  }

  /* 
  BUILDER
*/
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
                  SizedBox(height: 20),
                  Text(
                    "Step 1: Capture Tongue Images",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  imageSection(
                    context: context,
                    title: "Tongue Images",
                    images: tongueImages,
                    onAddImage: () => _addImage(tongueImages),
                    onReplaceImage: (index) =>
                        _replaceImage(tongueImages, index),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Step 2: Capture Teeth Images",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  imageSection(
                    context: context,
                    title: "Teeth Images",
                    images: teethImages,
                    onAddImage: () => _addImage(teethImages),
                    onReplaceImage: (index) =>
                        _replaceImage(teethImages, index),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Step 3: Capture Swelling Images",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  imageSection(
                    context: context,
                    title: "Swelling Images",
                    images: swellingImages,
                    onAddImage: () => _addImage(swellingImages),
                    onReplaceImage: (index) =>
                        _replaceImage(swellingImages, index),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Step 4: Record Solid Swallow Video",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  videoSection(
                    context: context,
                    title: "Solid Swallow Video",
                    file: solidVideo,
                    setFile: (f) => solidVideo = f,
                    setVideo: _setVideo,
                    videoController: _videoController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Step 5: Record Liquid Swallow Video",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  videoSection(
                    context: context,
                    title: "Liquid Swallow Video",
                    file: liquidVideo,
                    setFile: (f) => liquidVideo = f,
                    setVideo: _setVideo,
                    videoController: _videoController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Step 6: Record Mixed Swallow Video",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  videoSection(
                    context: context,
                    title: "Mixed Swallow Video",
                    file: mixedVideo,
                    setFile: (f) => mixedVideo = f,
                    setVideo: _setVideo,
                    videoController: _videoController,
                  ),
                  SizedBox(height: 20),
                  isSending
                      ? Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text(
                              "Uploading...",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        )
                      : ElevatedButton.icon(
                          onPressed: allCollected ? sendData : null,
                          icon: Icon(Icons.cloud_upload),
                          label: Text("Send Data"),
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

// --- Widgets used localy---

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
