import 'package:flutter/material.dart';
import 'package:ui/common/sweet_alert.dart';

class SweetAlertDemo extends StatelessWidget {
  const SweetAlertDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sweet Alert'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Success'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return SweetAlert.warning();
                });
          },
        ),
      ),
    );
  }
}
