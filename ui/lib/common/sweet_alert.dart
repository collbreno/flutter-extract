import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SweetAlert extends StatefulWidget {
  final String lottieAsset;
  final Widget? content;
  final Widget? title;
  final List<Widget>? actions;

  SweetAlert.warning({
    Key? key,
    this.content,
    this.title,
    this.actions,
  })  : lottieAsset = 'assets/lottie/warning_circle.json',
        super(key: key);

  SweetAlert.error({
    Key? key,
    this.content,
    this.title,
    this.actions,
  })  : lottieAsset = 'assets/lottie/error_circle.json',
        super(key: key);

  SweetAlert.success({
    Key? key,
    this.content,
    this.title,
    this.actions,
  })  : lottieAsset = 'assets/lottie/success_circle.json',
        super(key: key);

  @override
  _SweetAlertState createState() => _SweetAlertState();
}

class _SweetAlertState extends State<SweetAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 12),
      actions: widget.actions,
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      title: Column(
        children: [
          Lottie.asset(
            widget.lottieAsset,
            height: 120,
            width: 120,
            repeat: false,
          ),
          if (widget.title != null) widget.title!,
        ],
      ),
      content: widget.content,
    );
  }
}
