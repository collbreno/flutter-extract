import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;

  const ProgressDialog({
    Key? key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Row(
        children: [
          CircularProgressIndicator(),
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: content!,
            ),
        ],
      ),
    );
  }
}
