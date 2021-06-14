import 'package:flutter/material.dart';

class AppTheme {
  static final initTheme = ThemeData(
    primarySwatch: Colors.blue,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    accentColor: Colors.blue[800],
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
