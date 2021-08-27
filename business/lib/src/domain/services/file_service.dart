import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> copyFileToInternalDir(String tempPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final tempFile = File(tempPath);
    final fileName = tempFile.path.split('/').last;

    final newFile = await File(tempPath).copy('$appDir/$fileName');
    return newFile.path;
  }
}
