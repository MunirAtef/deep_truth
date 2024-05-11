
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import '../backend_logic/file_request.dart';


@Deprecated("Will be removed soon")
class CacheManager {
  static String? _cacheDirPath;

  static Future<String> _getCashedFilesDir() async {
    if (_cacheDirPath != null) return _cacheDirPath!;
    _cacheDirPath ??= "${(await getTemporaryDirectory()).path}/history_data";
    return _cacheDirPath!;
  }

  static Future<File?> getFile(String filename) async {
    String filePath = "${await _getCashedFilesDir()}/$filename";
    File file = File(filePath);
    if (file.existsSync()) return file;

    Uint8List? fileBytes = await FileRequest.inst.getFileBytes(filename);
    if (fileBytes == null) return null;

    return file
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes.toList());
  }

  static Future<void> deleteFile(String filename) async {
    try {
      String filePath = "${await _getCashedFilesDir()}/$filename";
      File(filePath).deleteSync();
    } catch (_) {}
  }

  static Future<void> clearHistory() async {
    try {
      Directory(await _getCashedFilesDir()).deleteSync(recursive: true);
    } catch (_) {}
  }
}

