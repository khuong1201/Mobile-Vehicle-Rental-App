import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<List<File>> convertXFilesToJpgFiles(Map<String, dynamic>? imagesMap) async {
  debugPrint('Starting convertXFilesToJpgFiles');
  if (imagesMap == null) {
    debugPrint('imagesMap is null');
    return [];
  }

  List<File> jpgFiles = [];

  for (var entry in imagesMap.entries) {
    debugPrint('Processing entry: ${entry.key}');
    final xfile = entry.value;
    if (xfile is XFile) {
      debugPrint('Found XFile for ${entry.key}: ${xfile.path}');
      try {
        final bytes = await xfile.readAsBytes();
        debugPrint('Read ${bytes.length} bytes for ${entry.key}');
        final decodedImage = img.decodeImage(bytes);

        if (decodedImage != null) {
          debugPrint('Decoded image successfully for ${entry.key}');
          final jpgBytes = img.encodeJpg(decodedImage, quality: 90);
          debugPrint('Encoded JPG with ${jpgBytes.length} bytes');

          final tempDir = await getTemporaryDirectory();
          final newPath = join(tempDir.path, '${entry.key}_${DateTime.now().millisecondsSinceEpoch}.jpg');
          debugPrint('Saving to: $newPath');
          final jpgFile = await File(newPath).writeAsBytes(jpgBytes);

          jpgFiles.add(jpgFile);
          debugPrint('Saved JPG file: ${jpgFile.path}');
        } else {
          debugPrint('Failed to decode image for ${entry.key}');
        }
      } catch (e) {
        debugPrint('Error processing ${entry.key}: $e');
      }
    } else {
      debugPrint('Invalid XFile for ${entry.key}: $xfile');
    }
  }

  debugPrint('Converted ${jpgFiles.length} files');
  return jpgFiles;
}