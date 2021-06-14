import 'package:flutter/material.dart';
import 'package:ui/common/app_theme.dart';
import 'package:ui/demo/page_transition_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.initTheme,
      home: PageTransitionDemo(),
    );
  }
}
