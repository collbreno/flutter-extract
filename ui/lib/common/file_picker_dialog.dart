import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:ui/common/thumbnail.dart';

Future<List<PlatformFile>?> showFilePickerDialog({
  required BuildContext context,
  List<PlatformFile>? initialFiles,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return FilePickerDialog(
        initialFiles: initialFiles,
      );
    },
  );
}

class FilePickerDialog extends StatefulWidget {
  final List<PlatformFile>? initialFiles;

  FilePickerDialog({
    this.initialFiles,
    Key? key,
  }) : super(key: key);

  @override
  _FilePickerDialogState createState() => _FilePickerDialogState();
}

class _FilePickerDialogState extends State<FilePickerDialog> {
  late List<PlatformFile> _platformFiles;
  File? _fileToPreview;

  @override
  void initState() {
    super.initState();
    _platformFiles = List.of(widget.initialFiles ?? []);
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: OutlinedButton(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
            allowMultiple: true,
          );
          if (result != null)
            setState(() {
              _platformFiles.addAll(result.files);
            });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 4),
            Text('Adicionar'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: Text('Anexos'),
          contentPadding: EdgeInsets.only(top: 20),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context, _platformFiles);
              },
            )
          ],
          content: _platformFiles.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nenhum anexo'),
                    SizedBox(height: 16),
                    _buildButton(),
                  ],
                )
              : Container(
                  height: 300,
                  width: double.maxFinite,
                  child: ListView(
                    children: [
                      ..._platformFiles.map(
                        (platformFile) {
                          return GestureDetector(
                            onLongPressEnd: (_) {
                              setState(() {
                                _fileToPreview = null;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                _fileToPreview = File(platformFile.path!);
                              });
                            },
                            onTap: () {
                              OpenFile.open(platformFile.path);
                            },
                            child: ListTile(
                              leading: Thumbnail(
                                file: File(platformFile.path!),
                                width: 48,
                                height: 48,
                              ),
                              title: Text(platformFile.name),
                              trailing: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _platformFiles.remove(platformFile);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      SizedBox(height: 12),
                      _buildButton(),
                    ],
                  ),
                ),
        ),
        if (_fileToPreview != null)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Center(
                child: Card(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 2 / 3,
                    decoration: ShapeDecoration(
                      shape: Theme.of(context).dialogTheme.shape!,
                    ),
                    child: Thumbnail(
                      file: _fileToPreview!,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
