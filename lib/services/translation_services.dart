import 'dart:async';
import 'dart:core';

import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../utils/constants.dart';

class TranslationServices {
  Future<String> extractAudio(String videoPath) async {
    // Get the path of the video file
    // Replace with the actual video file path

    // Create the output file path
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String outputPath = path.join(appDocDir.path, 'out.wav');

    // Define the FFmpeg command to extract audio
    final String command = '-i $videoPath -map 0:a -c:a pcm_s16le -ar 16000 -y $outputPath';

    // Run FFmpeg to extract audio
    final result = await FFmpegKit.execute(command);
    final returnCode = await result.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print('Audio extraction successful!');
      return outputPath;
    } else {
      print('Audio extraction failed. Error code: ${returnCode!.getValue()}');
      return "";
    }
  }

  Future<String?> getTranslatedAudio(String videoPath, String dest) async {
    final url = Uri.parse("${Constants.baseUrl}translate_audio/$dest");
    final request = http.MultipartRequest("POST", url);
    final video = File(videoPath);
    final header = {
      'Content-Type': 'multipart/form-data'
    };
    request.headers.addAll(header);
    final bytes = await video.readAsBytes();
    request.files.add( http.MultipartFile.fromBytes("file",bytes,filename: video.path.split("/").last));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await response.stream.toBytes();
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final filePath = '$tempPath/video.mp4';
      final file = await File(filePath).writeAsBytes(res);
      return file.path;
    } else {
      print("failed");
      return null;
    }
  }
}
