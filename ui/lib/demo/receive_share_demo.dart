import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:ui/common/sweet_alert.dart';
import 'package:ui/demo/sweet_alert_demo.dart';

class ReceiveShareDemo extends StatefulWidget {
  const ReceiveShareDemo({Key? key}) : super(key: key);

  @override
  _ReceiveShareDemoState createState() => _ReceiveShareDemoState();
}

class _ReceiveShareDemoState extends State<ReceiveShareDemo> {
  late StreamSubscription _streamSubscription;
  late List<SharedMediaFile> _sharedFiles;

  @override
  void initState() {
    super.initState();
    _sharedFiles = [];
    ReceiveSharingIntent.getInitialMedia().then((files) {
      setState(() {
        _sharedFiles = files;
      });
    });
    _streamSubscription = ReceiveSharingIntent.getMediaStream().listen((files) {
      setState(() {
        _sharedFiles = files;
      });
      print(files.map((e) => e.path).join(';'));
    }, onError: (err) {
      showDialog(
          context: context,
          builder: (ctx) => SweetAlert.error(
                title: Text('Error'),
              ));
      print("ERROR WHILE GETTING MEDIA STREAM $err");
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Share'),
      ),
      body: _sharedFiles.isEmpty
          ? Center(
              child: Text('Teste'),
            )
          : ListView.builder(
              itemCount: _sharedFiles.length,
              itemBuilder: (ctx, i) {
                final file = _sharedFiles[i];
                return ListTile(
                  leading: Image.file(File(file.path)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: SweetAlertDemo(),
                        type: PageTransitionType.size,
                        alignment: Alignment.bottomCenter,
                        duration: Duration(milliseconds: 500),
                        reverseDuration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuart,
                      ),
                    );
                  },
                  title: Text(file.path),
                );
              },
            ),
    );
  }
}
