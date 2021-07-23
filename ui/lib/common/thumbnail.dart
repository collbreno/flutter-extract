import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Thumbnail extends StatelessWidget {
  final File file;
  final double? height;
  final double? width;

  Thumbnail({
    Key? key,
    required this.file,
    this.height,
    this.width,
  }) : super(key: key);

  String get _extension => file.path.split('.').last;
  bool get _isImage => ['jpg', 'jpeg', 'png'].contains(_extension);
  bool get _isPdf => _extension == 'pdf';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: _buildThumb(context),
    );
  }

  Widget _buildThumb(BuildContext context) {
    if (_isImage) {
      return Image.file(file, width: width, height: height);
    } else if (_isPdf) {
      return AbsorbPointer(
        child: SfPdfViewer.file(
          file,
          canShowScrollHead: false,
          canShowScrollStatus: false,
          enableDoubleTapZooming: false,
          enableTextSelection: false,
          enableDocumentLinkAnnotation: false,
          canShowPaginationDialog: false,
        ),
      );
    } else {
      return Icon(Icons.error, color: Theme.of(context).colorScheme.error);
    }
  }
}
