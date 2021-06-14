import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue[800],
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, theme) {
        return MaterialApp(
          title: 'Extract',
          theme: theme,
          home: HomeScreen(),
        );
      },
    );
  }
}
