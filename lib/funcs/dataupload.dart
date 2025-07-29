// lib/funcs/data_upload.dart
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart'; // For AlertDialog, SnackBar, etc.
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/pages/login.dart';
import 'package:video_player/video_player.dart'; // Make sure this path is correct

// Function to check if a file exists on the remote server via SSH
Future<bool> checkRemoteExists(String path) async {
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

// Function to send all collected data
Future<void> sendAllData({
  required BuildContext context,
  required StateSetter setStateCallback, // Pass setState from the State
  required List<File> tongueImages,
  required List<File> teethImages,
  required List<File> swellingImages,
  required File? solidVideo,
  required File? liquidVideo,
  required File? mixedVideo,
  required Function(VideoPlayerController?)
  setVideoControllerToNull, // To reset controller
  required String patientId,
}) async {
  setStateCallback(
    () => {/* isSending = true */},
  ); // You'll update isSending in the calling State

  final dir = await getApplicationDocumentsDirectory();
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
  if (solidVideo != null) zip.addFile(solidVideo, 'solid_swallow.mp4');
  if (liquidVideo != null) zip.addFile(liquidVideo, 'liquid_swallow.mp4');
  if (mixedVideo != null) zip.addFile(mixedVideo, 'mixed_swallow.mp4');
  zip.close();

  final remotePath = '/home/medadmin/Documents/$zipName';
  if (await checkRemoteExists(remotePath)) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Replace Existing Data?"),
        content: const Text(
          "Data already exists for this patient today. Replace?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      setStateCallback(() {
        /* isSending = false */
      }); // You'll update isSending in the calling State
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

    // Clear data and reset UI
    setStateCallback(() {
      tongueImages.clear();
      teethImages.clear();
      swellingImages.clear();
      // Need to null out these outside this func or pass callbacks
      // solidVideo = null;
      // liquidVideo = null;
      // mixedVideo = null;
      // _videoController?.dispose();
      // _videoController = null;
    });
    // This part should also be handled by the calling state
    setVideoControllerToNull(null);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Upload completed successfully."),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("❌ Upload failed: $e")));
  } finally {
    setStateCallback(() {
      /* isSending = false */
    }); // You'll update isSending in the calling State
  }
}
